//
//  DrowableViewController.swift
//  NewsApp
//
//  Created by Wass on 20/04/2023.
//

import PencilKit
import UIKit

class DrowableViewController: UIViewController, PKCanvasViewDelegate {
    
    let backgroundImage: UIImage
    
    init(backgroundImage: UIImage) {
        self.backgroundImage = backgroundImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let canvasView: PKCanvasView = {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        return canvas
    }()

    // Define toolPicker here instead of inside `viewDidAppear` function
    private let toolPicker = PKToolPicker()

    let drawing = PKDrawing()

    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.backgroundColor = UIColor(patternImage: backgroundImage)
        canvasView.drawing = drawing
        canvasView.delegate = self
        view.addSubview(canvasView)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        canvasView.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Call `self.toolPicker` instead of just `toolPicker`
        self.toolPicker.setVisible(true, forFirstResponder: canvasView)
        self.toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
}
