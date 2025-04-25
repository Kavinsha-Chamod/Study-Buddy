//
//  DocumentScannerView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-24.
//

import SwiftUI
import VisionKit
import Vision

struct DocumentScannerView: UIViewControllerRepresentable {
    var onTextRecognized: (String) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(onTextRecognized: onTextRecognized)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let onTextRecognized: (String) -> Void

        init(onTextRecognized: @escaping (String) -> Void) {
            self.onTextRecognized = onTextRecognized
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                recognizeText(from: image)
            }
            controller.dismiss(animated: true)
        }

        private func recognizeText(from image: UIImage) {
            let request = VNRecognizeTextRequest { [weak self] request, error in
                guard let self = self else { return }
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

                let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
                let fullText = recognizedStrings.joined(separator: "\n")
                self.onTextRecognized(fullText)
            }

            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            try? handler.perform([request])
        }
    }
}
