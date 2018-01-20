//
//  ModuleFactory.swift
//  ViperArch
//
//  Created by Natali Polovnikova on 19.01.17.
//  Copyright © 2017 ideil. All rights reserved.
//

import UIKit

public protocol ModuleFactoryProtocol: class {
    func instantiateModuleTransitionHandler() -> ModuleTransitionHandler?
}

public class ModuleFactory: ModuleFactoryProtocol {
    public typealias ViewHandlerBlock = () -> ModuleTransitionHandler

    public var viewControllerLoader: UIStoryboard?
    public var viewControllerIdentifier: String?
    public var viewHandler: ViewHandlerBlock?

    public init(loader: UIStoryboard, viewControllerIdentifier identifier: String) {
        self.viewControllerLoader = loader
        self.viewControllerIdentifier = identifier
    }

    public init(viewHandler: @escaping ViewHandlerBlock) {
        self.viewHandler = viewHandler
    }

    public func instantiateModuleTransitionHandler() -> ModuleTransitionHandler? {
        if let viewHandler = viewHandler {
            return viewHandler()
        }

        guard let loader = viewControllerLoader,
            let identifier = viewControllerIdentifier
            else {
                return nil
        }

        let destinationViewController = loader.instantiateViewController(withIdentifier: identifier)
        return destinationViewController
    }

}
