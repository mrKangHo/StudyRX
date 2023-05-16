//
//  MainViewController.swift
//  ExReactor
//
//  Created by LEE on 2023/05/03.
//

import UIKit
import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa
import Then

class MainViewController: UIViewController, View {
     
    var disposeBag: DisposeBag
    typealias Reactor = MainViewReactor
    let btn = UIButton().then {
        $0.setTitle("불러오기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .blue
    }
    let tableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    init(_ reactor:MainViewReactor? = nil) {
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
        if reactor == nil {
            self.reactor = MainViewReactor()
        }
        else {
            self.reactor = reactor
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(btn)
        self.view.addSubview(tableView)
        
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.btn.pin.left().top(self.view.pin.safeArea).right().height(60)
        
        self.tableView.pin.left().top(to: self.btn.edge.bottom).right().bottom()
        
        
    }
    
    

    func bind(reactor: MainViewReactor) {
        self.btn.rx.tap
            .map{Reactor.Action.load}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.listData}.bind(to: tableView.rx.items(cellIdentifier: "cell")){ index, sss, cell in
            print(sss.email)
          }
          .disposed(by: disposeBag)
        
        
    }
 

}
