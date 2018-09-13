//
//  TokenVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/23/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import StatefulViewController
import MXParallaxHeader
import Lottie

protocol TokenVC_Delegate: class {
    func didPressRequest(for token: TokenObject, in controller: UIViewController)
    func didPressSend(for token: TokenObject, in controller: UIViewController)
    func didPressInfo(for token: TokenObject, in controller: UIViewController)
    func didPress(viewModel: TokenViewModel, transaction: Transaction, in controller: UIViewController)
}

class TokenVC: BaseViewController {
    
    private lazy var header: TokenHeaderView? = {
        guard let view: TokenHeaderView = Bundle.main.loadNibNamed("TokenHeaderView", owner: self, options: nil)?.first as? TokenHeaderView else{
            return .none
        }
        view.delegate = self
        return view
    }()
    
    private lazy var segmentedIndicatorView: SegmentedIndicatorView? = {
        guard let view: SegmentedIndicatorView = Bundle.main.loadNibNamed("SegmentedIndicatorView", owner: self, options: nil)?.first as? SegmentedIndicatorView else{
            return .none
        }
        
        return view
    }()
    private lazy var scrollView: MXScrollView = {
        let scrollView = MXScrollView()
        scrollView.parallaxHeader.delegate = self
        scrollView.parallaxHeader.view = header;
        scrollView.parallaxHeader.height = 260;
        scrollView.parallaxHeader.mode = .fill;
        scrollView.parallaxHeader.minimumHeight = 110;
        return scrollView
    }()
    let containerView = UIView()
    
    private lazy var pageViewController : UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        for view in pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
        let startingViewController: TransactionsPageView = viewControllerAtIndex(index: 0)!
        self.currentPageView = startingViewController
        let viewControllers = [startingViewController]
        pageViewController.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        return pageViewController
    }()
    
    var currentPageView: TransactionsPageView?{
        didSet{
            self.currentPageView?.didselectedItem = { [weak self] transaction in
                self?.delegate?.didPress(viewModel: (self?.viewModel)!, transaction: transaction, in: self!)
            }
        }
    }
    
    let quantityPage = 3
    let viewModel: TokenViewModel
    weak var delegate: TokenVC_Delegate?
    
    private lazy var loadingAnimationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "ball_stretch")
        animationView.contentMode = .scaleAspectFit
        animationView.loopAnimation = true
        return animationView
    }()
    
    init(viewModel: TokenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
       
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        self.createNavigator()
        scrollView.addSubview(containerView)
        addChildViewController(pageViewController)
        self.containerView.addSubview(pageViewController.view)
      
        pageViewController.didMove(toParentViewController: self)
        self.containerView.addSubview(self.segmentedIndicatorView!)
        self.segmentedIndicatorView?.didSelectedPage = { type in
//            if type == self.currentPageView?.type {return}
//            switch type {
//            case .All:
//                self.pageViewController.setViewControllers([self.viewControllerAtIndex(index: type.rawValue)!], direction: .reverse, animated: true, completion: nil)
//            case .Received:
//                self.pageViewController.setViewControllers([self.viewControllerAtIndex(index: type.rawValue)!], direction: type.rawValue > 1 ? .reverse : .forward, animated: true, completion: nil)
//            case .Sent:
//                self.pageViewController.setViewControllers([self.viewControllerAtIndex(index: type.rawValue)!], direction: .forward, animated: true, completion:nil)
//            }
            
        }
        
        // listenning update view token balance
        self.observToken()
        
        self.segmentedIndicatorView?.addSubview(loadingAnimationView)
        loadingAnimationView.loopAnimation = true
        loadingAnimationView.play()
        viewModel.transactionObservation {
            self.loadingAnimationView.stop()
        }

        
    }
    func createNavigator() {
        let menuBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = menuBarItem
    }
    
    deinit {
        viewModel.invalidateObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.frame
        scrollView.frame = frame
        scrollView.contentSize = frame.size
        frame.size.height -= scrollView.parallaxHeader.minimumHeight
        containerView.frame = frame
        loadingAnimationView.frame = CGRect(x: 0, y: (self.header?.bounds.height)! - 10, width: containerView.frame.size.width, height: 10)

        segmentedIndicatorView?.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: 40);
        segmentedIndicatorView?.pageViewScrollingProgress(progress: 0, currentPage: currentPageView?.type ?? .All)
        loadingAnimationView.frame = CGRect(x:containerView.frame.size.width - 260 , y:-20, width:100, height:80);
        pageViewController.view.frame = CGRect(x: 0, y: 40, width: containerView.frame.size.width, height: containerView.frame.size.height);
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetch()
        loadingAnimationView.play()
        self.updateHeaderView()
    }
    
    private func observToken() {
        viewModel.tokenObservation { [weak self] in
            self?.updateHeaderView()
        }
    }

    private func updateHeaderView(){
        self.header?.iconImage.kf.setImage(with: viewModel.imageURL, placeholder: viewModel.imagePlaceholder)
        self.header?.iconSmallImage.kf.setImage(with: viewModel.imageURL, placeholder: viewModel.imagePlaceholder)
        self.header?.balancelable.text = viewModel.amount
        self.header?.coinNameLable.text = viewModel.name
        self.header?.coinNameSmallLable.text = viewModel.name
        self.header?.symbolLable.text = viewModel.symbol
        self.header?.balanceSmallLable.text = viewModel.amount
        self.header?.symbolSmallLable.text = viewModel.symbol
    
    }
    
    
    func viewControllerAtIndex(index: Int) -> TransactionsPageView?
    {
        if self.quantityPage == 0
        {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
      
        let pageContentViewController = viewModel.createTransactionsPageView(type: TransactionsPageViewType(rawValue: index)!)
        return pageContentViewController
    }

    
}

// Update position Indicator Segmented View
extension TokenVC: UIScrollViewDelegate {
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distance =  self.view.bounds.width
        let progress = (scrollView.contentOffset.x  - distance) / distance
        self.segmentedIndicatorView?.pageViewScrollingProgress(progress: progress, currentPage: currentPageView?.type ?? .All)
    }

}

// MARK: - MXParallaxHeaderDelegate
extension TokenVC: MXParallaxHeaderDelegate{
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        self.header?.bigParentView.alpha = parallaxHeader.progress
        self.header?.smallParentView.alpha = 1 - parallaxHeader.progress

    }
}

extension TokenVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! TransactionsPageView).type.rawValue
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! TransactionsPageView).type.rawValue
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if (index == self.quantityPage) {
            return nil
        }
        
        return viewControllerAtIndex(index: index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.quantityPage
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (!completed){return}
        currentPageView = pageViewController.viewControllers?.first as? TransactionsPageView
    }

}
extension TokenVC: TokenHeaderView_Delegate{
    func didPressSend() {
        self.delegate?.didPressSend(for: viewModel.token, in: self)
        
    }
    
    func didPressReveice() {
        self.delegate?.didPressRequest(for: viewModel.token, in: self)
        
    }
    
}


