import SwiftUI
import RealityKit
import AppKit // Dla macOS

// Używamy aliasów, aby uniknąć konfliktu między SwiftUI.Scene a RealityKit.Scene
typealias AppScene = SwiftUI.Scene
typealias AppView = SwiftUI.View

@main
struct MinimalMacApp: SwiftUI.App {
    var body: some AppScene {
        WindowGroup {
            ContentView()
                .frame(width: 800, height: 600)
        }
    }
}

struct ContentView: NSViewRepresentable {
    func makeNSView(context: Context) -> ARView {
        let arView = ARView(frame: CGRect(x: 0, y: 0, width: 800, height: 600))

        let box = ModelEntity(
            mesh: .generateBox(size: 0.3),
            materials: [SimpleMaterial(color: .purple, isMetallic: false)] // Poprawiono: 'materials' zamiast 'metals'
        )
        box.position = SIMD3<Float>(0, 0, -1)

        let anchor = AnchorEntity(world: .zero)
        anchor.addChild(box)
        arView.scene.anchors.append(anchor)

        return arView
    }

    func updateNSView(_ nsView: ARView, context: Context) {}
}
