//
//  PresentationViewTests.swift
//  SwiftLens
//
//  Created by Karin Prater on 03/05/2025.
//

import Foundation
import Testing
@testable import SwiftLens
@testable import SwiftLensTestSupport

struct ContainerViewTests {

    @MainActor
    @Test
    func container_tests() async throws {
        // —— SYSTEM SETUP ——
        let sut = UIUnderTest { sut in
            DemoContainerView()
        }
        
        #expect(sut.observer.values.count == 3)
        #expect(sut.observer.containsView(withID: "First"))
        #expect(sut.observer.containsView(withID: "Second"))
        #expect(sut.observer.containsView(withID: "Third"))
    }
    
    @MainActor
    @Test
    func nested_container_tests() async throws {
        // —— SYSTEM SETUP ——
        let sut = UIUnderTest { sut in
            DemoContainerNestedView()
        }
        
        #expect(sut.observer.values.count == 2)
        #expect(sut.observer.containsView(withID: "First"))
        #expect(sut.observer.containsView(withID: "Second"))
        #expect(sut.observer.containsView(withID: "Third"))
        
        let containerView = sut.observer.values.findView(withID: "container")
        #expect(containerView?.children.count == 2)
        #expect(containerView?.children[0].identifier == "Second")
        #expect(containerView?.children[1].identifier == "Third")
        
        sut.observer.printValues()
    }
    
    @MainActor
    @Test
    func background_container_tests() async throws {
        // —— SYSTEM SETUP ——
        let sut = UIUnderTest { sut in
            DemoContainerBackgroundView()
        }
        
        #expect(sut.observer.values.count == 3)
        #expect(sut.observer.containsView(withID: "First"))
        #expect(sut.observer.containsView(withID: "Backround.id")) // background view in parallel to container
        
        let containerView = sut.observer.values.findView(withID: "container")
        #expect(containerView?.children.count == 2)
        #expect(containerView?.children[0].identifier == "Second")
        #expect(containerView?.children[1].identifier == "Third")
        
        sut.observer.printValues()
    }
    
    @MainActor
    @Test
    func zstack_container_tests() async throws {
        // —— SYSTEM SETUP ——
        let sut = UIUnderTest { sut in
            DemoContainerZStackView()
        }
        sut.observer.printValues()
        
        #expect(sut.observer.values.count == 2)
        #expect(sut.observer.containsView(withID: "First")) // background view in parallel to container
        
        let containerView = sut.observer.values.findView(withID: "ZStack.container")
        #expect(containerView?.children.count == 3)
        #expect(containerView?.children[0].identifier == "Yellow")
        #expect(containerView?.children[1].identifier == "Second")
        #expect(containerView?.children[2].identifier == "Third")
        
        sut.observer.printValues()
    }
}
