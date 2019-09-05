//
//  ModuleTransitionHandler.swift
//  ViperArch
//
//  Created by Eduard Pelesh on 10/17/16.
//  Copyright © 2016 ideil. All rights reserved.
//

import UIKit

public typealias ModuleTransitionBlock = (_ sourceModuleTransitionHandler: ModuleTransitionHandler?, _ destinationModuleTransitionHandler: ModuleTransitionHandler?) -> Void

public protocol ModuleTransitionHandler: class {
    var moduleInput: ModuleInput? { get set }

    func performSegue(withIdentifier identifier: String)

    func openModuleUsingSegue(withIdentifier identifier: String) -> OpenModulePromise

    func openModuleUsingFactory(_ factory: ModuleFactoryProtocol, withTransitionBlock transitionBlock: ModuleTransitionBlock?) -> OpenModulePromise

    func closeCurrentModule(animated: Bool)
}

public extension ModuleTransitionHandler {
    var moduleInput: ModuleInput? { return nil }

    func performSegue(withIdentifier identifier: String) {}

    func openModuleUsingSegue(withIdentifier identifier: String) -> OpenModulePromise {
        return OpenModulePromise()
    }

    func openModuleUsingFactory(_ factory: ModuleFactoryProtocol, withTransitionBlock transitionBlock: ModuleTransitionBlock?) -> OpenModulePromise {
        return OpenModulePromise()
    }

    func closeCurrentModule(animated: Bool) {}
}

extension UIViewController: ModuleTransitionHandler {
    private struct AssociatedKeys {
        static var moduleInput = "idl_moduleInput"
        static var traditionalModuleInput = "output"
    }

    public var moduleInput: ModuleInput? {

        get {
            if let result = objc_getAssociatedObject(self, AssociatedKeys.moduleInput) as? ModuleInput {
                return result
            }

            let ivar = class_getInstanceVariable(type(of: self), AssociatedKeys.traditionalModuleInput)

            return object_getIvar(self, ivar!) as? ModuleInput
        }

        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    AssociatedKeys.moduleInput,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }

    @objc
    open class func segueSwizzle() {
        struct Static {
            static var token: String = "com.ideil.ios.segueswizzle"
        }

        if self !== UIViewController.self {
            return
        }

        DispatchQueue.once(token: Static.token) {
            let originalSelector = #selector(UIViewController.prepare)
            let swizzledSelector = #selector(UIViewController.viperPrepare)

            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)

            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }

    @objc
    func viperPrepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.viperPrepare(for: segue, sender: sender)

        guard let promise = sender as? OpenModulePromise else { return }

        var destinationViewController: UIViewController? = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.topViewController
        }

        let targetModuleTransitionHandler = destinationViewController
        promise.moduleInput = targetModuleTransitionHandler?.moduleInput
    }

    public func performSegue(withIdentifier identifier: String) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: identifier, sender: nil)
        }
    }

    public func openModuleUsingSegue(withIdentifier identifier: String) -> OpenModulePromise {
        let openModulePromise = OpenModulePromise()
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: identifier, sender: openModulePromise)
        }
        
        return openModulePromise
    }

    public func openModuleUsingFactory(_ factory: ModuleFactoryProtocol, withTransitionBlock transitionBlock: ModuleTransitionBlock?) -> OpenModulePromise {
        let openModulePromise = OpenModulePromise()

        let destinationModuleTransitionHandler = factory.instantiateModuleTransitionHandler()
        var moduleInput: ModuleInput? = nil
        if let input = destinationModuleTransitionHandler?.moduleInput {
            moduleInput = input
        }

        openModulePromise.moduleInput = moduleInput
        if let transition = transitionBlock {
            openModulePromise.postLinkActionBlock = {
                DispatchQueue.main.async {
                    transition(self, destinationModuleTransitionHandler)
                }
            }
        }

        return openModulePromise
    }

    public func closeCurrentModule(animated: Bool) {
        var isInNavigationStack = false
        var hasManyControllersInStack = false

        if let navigationController = parent as? UINavigationController {
            isInNavigationStack = true
            hasManyControllersInStack = navigationController.viewControllers.count > 1
        }

        if isInNavigationStack && hasManyControllersInStack {
            let _ = (parent as? UINavigationController)?.popViewController(animated: animated)
        } else if presentingViewController != nil {
            dismiss(animated: animated)
        } else if view.superview != nil {
            removeFromParent()
            view.removeFromSuperview()
        }
    }

}

public extension DispatchQueue {

    private static var _onceTracker = [String]()

    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block()
    }
}
