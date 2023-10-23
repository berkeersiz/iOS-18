//
//  ViewController.swift
//  SignInWithApple
//
//  Created by Berke Ersiz on 10.12.2022.
//

import UIKit
import AuthenticationServices // AuthorizationAppleProviderı kullanabilmemiz için!
import MBProgressHUD
import NVActivityIndicatorView//Kütüphaneleri kullanabilmemiz için import ettik.
var hud: MBProgressHUD = MBProgressHUD()

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progressBar = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressBar.label.text = "Loading.."
        progressBar.isUserInteractionEnabled = false
        
       /* DispatchQueue.main.async {
           // do something
            progressBar.hide(animated: true)
        }*/
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            progressBar.hide(animated: true)
            
        
        }
        
        
        

        
    }
    

    @IBAction func signInWithApple(_ sender: UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider() //apple provider.
        let request = appleIDProvider.createRequest()//Bir istek oluşturduk.
        request.requestedScopes = [.fullName , .email]//İsteklerin ne oldugu.
        let authorizantionController = ASAuthorizationController(authorizationRequests: [request])//requestleri kontrol etmek için yolladık ve dizi halinde yolladık birden çok requestimiz olabilir.
        authorizantionController.delegate = self//uyarı verdi protokolü implement etmemiz gerekiyor extension olarak.
        
        authorizantionController.performRequests()//requesti yerine getir.
        
    }
    
}

extension ViewController: ASAuthorizationControllerDelegate{
    func authorizationController(authorizantionController: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {//alta eger girersek neler olucak bilgiler genelde credential olarak alınır.
        
        
        switch authorization.credential{
        case let credential as ASAuthorizationAppleIDCredential:
            let firstName = credential.fullName?.givenName
            let lastName = credential.fullName?.familyName
            let email = credential.email
            print(firstName!)
            print(lastName!)
            print(email!)
            
            break
        default:
            break
        }
        /*if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential{
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            
            print(userIdentifier)
            print(fullName)
            print(email)
            
        }*/
    }
    func authorizationController(authorizantionController: ASAuthorizationController, didCompleteWithError error: Error) {
        //print(error.localizedDescription)
        print("error")
    }
    
    
    
    //normalde bu kısmı appdelagete tarafında da yapılabilir.
    /*private func getCredentialState(userId: String){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userId) { credentialState, error in
            switch credentialState{
            case .authorized:
                print("giriş sağlandı")
                break
            case .revoked, .notFound:
                DispatchQueue.main.async {
                    print("giriş sağlanamadı")
                }
            case .transferred:
                break
            @unknown default:
                break
            }
        }
    }*/
}

