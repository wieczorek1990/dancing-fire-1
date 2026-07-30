
import SwiftUI
import RealityKit
import AppKit

@main
struct MinimalMacApp: SwiftUI.App {
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
                .frame(width: 800, height: 600)
        }
    }
}

struct ContentView: NSViewRepresentable {
    func makeNSView(context: Context) -> ARView {
        let arView = ARView(frame: CGRect(x: 0, y: 0, width: 800, height: 600))

        let flameGroup = AnchorEntity(world: .zero)

        // --- Helper to create a flame segment ---
        func createFlameSegment(width: Float, height: Float, yOffset: Float, color: NSColor, speed: Float) -> ModelEntity {
            let mesh = MeshResource.generateBox(width: width, height: height, depth: width * 0.8)
            let material = SimpleMaterial(color: color, isMetallic: false)
            let entity = ModelEntity(mesh: mesh, materials: [material])

            entity.position = SIMD3<Float>(0, yOffset, 0)

            animatePart(entity: entity, speed: speed, scaleRange: 0.25, wiggle: 0.04)

            return entity
        }

        // 1. Bottom (Deep Red) - Wide, slow
        let red = createFlameSegment(width: 0.5, height: 0.7, yOffset: -0.35, color: .red, speed: 6.0)
        flameGroup.addChild(red)

        // 2. Middle (Bright Orange) - Medium, medium
        let orange = createFlameSegment(width: 0.4, height: 0.8, yOffset: 0.0, color: .orange, speed: 10.0)
        flameGroup.addChild(orange)

        // 3. Top (Yellow) - Narrow, fast
        let yellow = createFlameSegment(width: 0.25, height: 0.6, yOffset: 0.4, color: .yellow, speed: 16.0)
        flameGroup.addChild(yellow)

        // Place the whole flame in front of the camera
        flameGroup.position = SIMD3<Float>(0, 0, -1.5)

        arView.scene.anchors.append(flameGroup)

        return arView
    }

    func updateNSView(_ nsView: ARView, context: Context) {}

    private func animatePart(entity: ModelEntity, speed: Float, scaleRange: Float, wiggle: Float) {
        var elapsed: TimeInterval = 0
        let timer: Timer = Timer(timeInterval: 1.0 / 60.0, repeats: true) { _ in
            elapsed += 1.0 / 60.0
            let t = Float(elapsed)

            // Unique phase offset based on speed to prevent synchronized jumping
            let phaseOffset = speed * 0.1

            let scaleY = 1.0 + Float(sin(Double(t * speed + phaseOffset))) * scaleRange
            let scaleXZ = 1.0 + Float(cos(Double(t * speed * 0.9 + phaseOffset))) * (scaleRange * 0.5)

            let wiggleX = Float(sin(Double(t * speed * 1.1 + phaseOffset))) * wiggle
            let wiggleY = Float(cos(Double(t * speed * 0.8 + phaseOffset))) * wiggle

            var transform = entity.transform
            transform.scale = SIMD3<Float>(scaleXZ, scaleY, scaleXZ)
            transform.translation = SIMD3<Float>(wiggleX, wiggleY, 0)

            // Gentle rotation
            let rot = Float(sin(Double(t * speed * 0.4 + phaseOffset))) * 0.15
            transform.rotation = simd_quatf(angle: rot, axis: SIMD3<Float>(0, 1, 0))

            entity.transform = transform
        }
        RunLoop.main.add(timer, forMode: .common)
    }
}
