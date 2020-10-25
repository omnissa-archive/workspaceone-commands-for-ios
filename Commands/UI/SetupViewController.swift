//
//  SetupViewController.swift
//  Action
//
//  Created by Mohammed Lazim on 7/8/19.
//  Updated by Paul Evans on 5/12/20.
//  Copyright © 2019-2020 VMware, Inc.

import UIKit

class SetupViewController: UIViewController {

    var testConfig: [String: Any] {
      return [
            "DEVICE_UID": "asdfsadf",
            "API_HOSTNAME": "https://cnaapp.ssdevrd/api",
            "API_KEY": "asdfsadf",
            "API_USERNAME": "naveen",
            "API_PASSWORD": "naveen5",
            "ENABLE_TROUBLESHOOTING": 1,
            "ACTION_WIPE": 1,
            "ACTION_ENTERPRISEWIPE": 1,
            "ACTION_CLEARPASSCODE": 1,
            "ACTION_SYNC": 1,
        ]
    }

    var isTestSetup: Bool = false

    lazy var contextSetupProvider: UserDefaultsContextSetupProvider = ManagedConfigurationContextSetupProvider(context: self.context)
    lazy var storedConfigContextSetupProvider: UserDefaultsContextSetupProvider = StoredConfigurationContextSetupProvider(context: self.context)

    var context: ApplicationContext { return .shared }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var errorImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.global().async {  [weak self] in
            self?.setupContext()
        }
    }

    // MARK: Context Setup Operation & results
    func setupContext() {

        if self.isTestSetup {
            self.handleSetup(status: self.contextSetupProvider.setup(with: self.testConfig))
        } else {
            self.handleSetup(status: self.contextSetupProvider.setup())
        }

    }

    func handleSetup(status: ContextSetupStatus) {

        if case .success = status {
            self.setupFinished()
            return
        }

        guard case .missingConfigInfo = status else {
            self.setupFailed(error: status)
            return
        }

        // Only if we have an option to use stored config, go forward
        guard self.canUseStoredConfiguration() else {
            self.setupFailed(error: status)
            return
        }

        // Managed settings are missing. We have two options now:
        // 1. Check if have a stored config (that user entered previously)
        // 2. Prompt user for new config

        let storedConfigStatus = self.storedConfigContextSetupProvider.setup()

        switch storedConfigStatus {
        case .success:
            self.setupFinished()

        case .missingConfigInfo:
            self.showConfigurationPrompt()

        default:
            self.setupFailed(error: status)
        }
    }

    private func canUseStoredConfiguration() -> Bool {
        return true
    }

    func setupFinished() {
        /// 🎊 We're ready to beging the show
        /// Show dashboard screen

        let screenIdentifier = DashboardViewController.screenIdentifier

        DispatchQueue.main.async { [weak self] in
            /// No need to animate.
            /// Since this VC is there only for a micro-seconds, user should
            /// believe that the first screen is dashboard itself.
            let screen = DashboardViewController.storyboard.instantiateViewController(withIdentifier: screenIdentifier)
            let presentable = UINavigationController(rootViewController: screen)
            presentable.modalPresentationStyle = .fullScreen
            self?.present(presentable, animated: false, completion: nil)
        }

    }

    func setupFailed(error: ContextSetupStatus) {
        self.showError(description: error.errorDescription())
    }


    // MARK: Screen state change
    func showActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = false
            self?.errorLabel.isHidden = true
            self?.errorDescriptionLabel.isHidden = true
            self?.errorImage.isHidden = true
        }
    }

    func showError(description: String) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.errorLabel.isHidden = false
            self?.errorDescriptionLabel.isHidden = false
            self?.errorImage.isHidden = false

            self?.errorDescriptionLabel.text = description
        }
    }

    func showConfigurationPrompt() {
        let screenIdentifier = ConfigurationViewController.screenIdentifier

        DispatchQueue.main.async { [weak self] in
            let screen = ConfigurationViewController.storyboard.instantiateViewController(withIdentifier: screenIdentifier)
            screen.modalPresentationStyle = .fullScreen
            self?.present(screen, animated: false, completion: nil)
        }
    }

}
