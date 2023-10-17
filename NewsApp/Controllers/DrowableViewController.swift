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
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
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

    private let toolPicker = PKToolPicker()

    let drawing = PKDrawing()

    override func viewDidLoad() {
        super.viewDidLoad()
        createCanvasView()
        createTopView()
        createNavItemButtons()

    }
    
    // Create canvas view
    func createCanvasView() {
        canvasView.backgroundColor = UIColor(patternImage: backgroundImage)
        canvasView.drawing = drawing
        canvasView.delegate = self
        view.addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        canvasView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        canvasView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    // Create top view
    func createTopView() {
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topView.isUserInteractionEnabled = true
    }
    
    // Create navItemsButtons
    func createNavItemButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareButtonPressed))
    }
    
    // Action when dismissButton is pressed
    @objc func dismissButtonPressed() {
        self.dismiss(animated: true)
    }
    
    // Action when shareButton is pressed
    @objc func shareButtonPressed() {
        let image = self.canvasView.takeScreenShot()
        let activityController = UIActivityViewController(activityItems: [image] , applicationActivities: nil)
        present(activityController, animated: true)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Call `self.toolPicker` instead of just `toolPicker`
        self.toolPicker.setVisible(true, forFirstResponder: canvasView)
        self.toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
}

