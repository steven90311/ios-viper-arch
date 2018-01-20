//
//  OpenModulePromise.swift
//  ViperArch
//
//  Created by Eduard Pelesh on 10/17/16.
//  Copyright © 2016 ideil. All rights reserved.
//

import Foundation

public typealias PostLinkActionBlock = () -> Void
public typealias ModuleLinkBlock = (_ moduleInput: ModuleInput?) -> ModuleOutput?

public class OpenModulePromise: NSObject {
    
    public var moduleInput: ModuleInput? {
        didSet {
            moduleInputWasSet = true
            tryPerformLink()
        }
    }
    public var postLinkActionBlock: PostLinkActionBlock?
    
    private var linkBlock: ModuleLinkBlock?
    private var linkBlockWasSet: Bool = false
    private var moduleInputWasSet: Bool = false
    
    public func thenChain(using block: @escaping ModuleLinkBlock) {
        linkBlock = block
        linkBlockWasSet = true
        tryPerformLink()
    }
    
    private func tryPerformLink() {
        guard linkBlockWasSet && moduleInputWasSet else { return }
        
        performLink()
    }
    
    private func performLink() {
        guard let linkBlock = linkBlock else { return }
        
        if let moduleOutput: ModuleOutput = linkBlock(moduleInput) {
            moduleInput?.set(moduleOutput: moduleOutput)
        }
        
        postLinkActionBlock?()
    }
    
}
