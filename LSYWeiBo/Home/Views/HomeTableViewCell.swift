//
//  HomeNormalTableViewCell.swift
//  LSYWeiBo
//
//  Created by 李世洋 on 16/5/10.
//  Copyright © 2016年 李世洋. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import HYLabel

enum CellReuseIdentifier: String {
    case original = "originalIdentifier"
    case forward = "forwardIdentifier"
    case line = "recordLine"
    
    // 获取 cell 重用标示
    static func cellID(statues: Statuses) -> String {
        if statues.recordLine == true {
            return CellReuseIdentifier.line.rawValue
        }
       return statues.retweeted_status != nil ? CellReuseIdentifier.forward.rawValue : CellReuseIdentifier.original.rawValue
    }
}

protocol HomeTableViewCellDelegate: NSObjectProtocol {
    func downBtnDidSelected(btn: UIButton)
    func linkTap(link: String)
    func forwardBtnClic(btn: UIButton)
}

class HomeTableViewCell: UITableViewCell {

    weak var delegate: HomeTableViewCellDelegate?
    
    var statues: Statuses?
    {
        didSet{
            
            topView.statues = statues
            pictureView.statues = statues
            bottomView.status = statues
            pic_size = pictureView.calculationPicSize()
           
            pictureView.snp_updateConstraints { (make) in
                make.height.equalTo(pic_size!.height).priorityHigh()
                make.width.equalTo(pic_size!.width).priorityHigh()
                
                pic_size!.height == 0 ? make.bottom.equalTo(bottomView.snp_top).priorityHigh() : make.bottom.equalTo(bottomView.snp_top).offset(-10).priorityHigh()
            }
        }
    }
    
    var pic_size: CGSize?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUI()
        
        // MARK: - downBtnWillClick
        topView.downComplete = {[weak self] btn in
            
            self!.delegate?.downBtnDidSelected(btn)
        }
        
        // MARK: - 网页链接
        topView.linkComplete = {[weak self] link in
            
            self!.delegate?.linkTap(link)
        }
    }

    // 布局
    func setUI() {
    
        contentView.addSubview(topView)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        topView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView.snp_top)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
        }
    }

    // 顶部
    lazy var topView: TopView = {
        
        let top = "TopView".loadNib(self) as! TopView
        
        return top
    }()
    
    // 配图
    lazy var pictureView: PictureView = PictureView()
    
    // 底部
    lazy var bottomView: BottomView = {
        let bottom = "BottomView".loadNib(self) as! BottomView
        return bottom
    }()
    
    // 转发背景
    lazy var backgroundButton: UIButton = {
        let b = UIButton()
        b.setUpBackGroundInfo("timeline_card_middle_background_highlighted")
        b.addTarget(self, action: .bckBtnClick, forControlEvents: .TouchUpInside)
        return b
    }()
    
    // 转发内容
    lazy var forwardContent: HYLabel = {
        let label = HYLabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        label.opaque = true
        label.backgroundColor = UIColor.clearColor()
        return label
    }()
    
    @objc private func bckBtnDidClick(btn: UIButton) {
        delegate?.forwardBtnClic(btn)
    }
}


private extension Selector {
    static let bckBtnClick = #selector(HomeTableViewCell.bckBtnDidClick(_:))
}