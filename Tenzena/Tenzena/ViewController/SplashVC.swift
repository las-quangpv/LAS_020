//
//  SplashVC.swift
//  VancedPlayer
//
//  Created by VancedPlayer on 08/05/2023.
//

import UIKit
import Lottie
import GoogleMobileAds
import AppTrackingTransparency
import AppLovinSDK
import UserMessagingPlatform

class SplashVC: UIViewController {
    
    @IBOutlet weak var viewLoading: UIView!
    
    private let animationLoading = LottieAnimationView(name: "anim_loading")
    private var timer: Timer?
    private var timeLoading = 3
    private var isMobileAdsStartCalled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        requestConsent()
        
    }
    
    private func requestConsent() {
        let parameters = UMPRequestParameters()
        parameters.tagForUnderAgeOfConsent = false
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) { [weak self] requestConsentError in
            guard let self else { return }
            
            if let consentError = requestConsentError {
                self.timerStartErrorConsent()
                return print("Error: \(consentError.localizedDescription)")
            }
            
            UMPConsentForm.loadAndPresentIfRequired(from: self) { [weak self] loadAndPresentError in
                guard let self else {
                    self?.timerStartErrorConsent()
                    return
                }
                
                if let consentError = loadAndPresentError {
                    self.timerStartErrorConsent()
                    return print("Error: \(consentError.localizedDescription)")
                }
                if UMPConsentInformation.sharedInstance.canRequestAds {
                    self.startGoogleMobileAdsSDK()
                }
            }
        }
        if UMPConsentInformation.sharedInstance.canRequestAds {
            startGoogleMobileAdsSDK()
        }
    }
    
    private func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else { return }
            self.isMobileAdsStartCalled = true
            IdfaService.shared.requestTracking {
                GADMobileAds.sharedInstance().start { _ in
                    AdmodOpen.shared.loadAdmobOpen()
                    self.timerStart()
                }
            }
            ALSdk.shared()!.mediationProvider = "max"
            ALSdk.shared()!.initializeSdk { _ in
            }
        }
    }
    
    private func timerStartErrorConsent() {
        IdfaService.shared.requestTracking {
            GADMobileAds.sharedInstance().start { _ in
                AdmodOpen.shared.loadAdmobOpen()
                self.timerStart()
            }
        }
    }
    
    private func timerStart() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.countLoading)), userInfo: nil, repeats: true)
    }
    
    @objc func countLoading() {
        if timeLoading == 0 {
            timeLoading = timeLoading - 1
            timer?.invalidate()
            timer = nil
            self.navigationController?.pushViewController(BottomNavigationVC(), animated: true)
        } else {
            timeLoading = timeLoading - 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationLoading.contentMode = .scaleAspectFit
        viewLoading.addSubview(animationLoading)
        animationLoading.frame = CGRect(x: 0, y: 0, width: viewLoading.frame.width, height: viewLoading.frame.height)
        DispatchQueue.main.async {
            self.animationLoading.play(fromProgress: 0,
                                       toProgress: 1,
                                       loopMode: LottieLoopMode.loop,
                                       completion: { (finished) in})
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.animationLoading.stop()
    }
}
