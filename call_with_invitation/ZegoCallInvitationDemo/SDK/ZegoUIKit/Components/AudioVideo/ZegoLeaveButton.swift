//
//  QuitButton.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/25.
//

import UIKit

public protocol LeaveButtonDelegate: AnyObject {
    func onLeaveButtonClick(_ isLeave: Bool)
}

extension LeaveButtonDelegate {
    func onLeaveButtonClick(_ isLeave: Bool) { }
}

public class ZegoLeaveConfirmDialogInfo: NSObject {
    public var title: String?
    public var message: String?
    public var cancleButtonName: String?
    public var confirmButtomName: String?
    public weak var dialogPresentVC: UIViewController?
}

open class ZegoLeaveButton: UIButton {

    public weak var delegate: LeaveButtonDelegate?
    public var quitConfirmDialogInfo: ZegoLeaveConfirmDialogInfo = ZegoLeaveConfirmDialogInfo()
    public var iconLeave: UIImage = ZegoUIIconSet.iconPhone
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(self.iconLeave, for: .normal)
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClick() {
        if let showDialogVC = self.quitConfirmDialogInfo.dialogPresentVC {
            self.showDialog(showDialogVC)
        } else {
            ZegoUIKit.shared.leaveRoom()
            self.delegate?.onLeaveButtonClick(true)
        }
    }
    
    private func showDialog(_ showDialogVC: UIViewController) {
        var dialogTitle: String = "Leave the room"
        if let title = self.quitConfirmDialogInfo.title {
            dialogTitle = title
        }
        var dialogMessage: String = "Are you sure to leave room?"
        if let message = self.quitConfirmDialogInfo.message {
            dialogMessage = message
        }
        var cancelName: String = "Cancel"
        if let cancleButtonName = self.quitConfirmDialogInfo.cancleButtonName {
            cancelName = cancleButtonName
        }
        var sureName: String = "Confirm"
        if let confirmButtomName = self.quitConfirmDialogInfo.confirmButtomName {
            sureName = confirmButtomName
        }
        let alterView = UIAlertController.init(title: dialogTitle, message: dialogMessage, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction.init(title: cancelName, style: .cancel) { action in
            self.delegate?.onLeaveButtonClick(false)
        }
        let sureAction: UIAlertAction = UIAlertAction.init(title: sureName, style: .default) { action in
            ZegoUIKit.shared.leaveRoom()
            self.delegate?.onLeaveButtonClick(true)
        }
        alterView.addAction(cancelAction)
        alterView.addAction(sureAction)
        showDialogVC.present(alterView, animated: false, completion: nil)
    }

}
