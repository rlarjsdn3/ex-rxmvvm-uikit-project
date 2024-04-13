//
//  ViewController.swift
//  ExRxMVVM
//
//  Created by 김건우 on 4/13/24.
//

import UIKit

import RxCocoa
import RxSwift
import Then
import SnapKit

final class GitViewController: UIViewController {

    // MARK: - Typealias
    typealias ViewModel = GitViewModel

    // MARK: - Views
    private var searchController = UISearchController()
    private var tableView = UITableView()
    private var totalCountLabel = UILabel()
    
    // MARK: - Properties
    var viewModel: GitViewModel!
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Intializer
    convenience init(viewModel: GitViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupAttributes()
        
        bindViewModel()
    }

    // MARK: - Bind
    func bindViewModel() {
        assert(viewModel != nil)
        
        let input = GitViewModel.Input(
            inputText: searchController.searchBar.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.repositories
            .drive(tableView.rx.items(cellIdentifier: TableViewCell.reuseId)) { index, item, cell in
                var config = cell.defaultContentConfiguration()
                config.text = item.fullName
                cell.contentConfiguration = config
            }
            .disposed(by: disposeBag)
        
        output.totalCount
            .map { "검색 리포지토리 수: \($0)" }
            .drive(totalCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup
    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(totalCountLabel)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(totalCountLabel.snp.top)
        }
        
        totalCountLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func setupAttributes() {
        view.backgroundColor = UIColor.white
        
        tableView.do { view in
            view.allowsSelection = false
            view.rowHeight = UITableView.automaticDimension
            
            view.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseId)
        }
        
        totalCountLabel.do { view in
            view.font = UIFont.boldSystemFont(ofSize: 24)
            view.textAlignment = .center
            view.backgroundColor = UIColor.white
        }
        
        self.navigationItem.title = "Repository"
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

// MARK: - Extensions
extension GitViewController {
    
}

