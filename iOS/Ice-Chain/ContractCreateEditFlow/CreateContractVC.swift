//
//  PageViewController.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 8/26/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class CreateContractVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageControl = UIPageControl()
    
    lazy var pages: [UIViewController] = {
        return [self.newVc(viewController: "BasicInfo"),
                self.newVc(viewController: "TempRange"),
                self.newVc(viewController: "Deadline"),
                self.newVc(viewController: "CargoValue"),
                self.newVc(viewController: "DisplayContract")
                ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up first view that will show up on page control
        if let firstViewController = pages.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        // Set up page control
        self.delegate = self
        self.dataSource = self
        configurePageControl()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        
        // User is on first VC and swiped left to loop to last VC
        guard previousIndex >= 0 else {
//            return orderedViewControllers.last
            // Uncomment below and remove the line above if you don't want page control to loop
            
            return nil
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = pages.count
        
        // User is on last VC and swiped right to loop to first controller
        guard orderedViewControllersCount != nextIndex else {
//            return orderedViewControllers.first
            // Uncomment below and remove line above if you don't want page control to loop
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    // MARK: Delegate functions
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pages.index(of: pageContentViewController)!
    }
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func configurePageControl() {
        // The total number of pages avaialble is based on how many available colors we have
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.tintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
    }
}
