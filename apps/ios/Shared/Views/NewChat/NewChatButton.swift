//
//  NewChatButton.swift
//  SimpleX
//
//  Created by Evgeny Poberezkin on 31/01/2022.
//  Copyright © 2022 SimpleX Chat. All rights reserved.
//

import SwiftUI
import SimpleXChat

enum NewChatAction: Identifiable {
    case createLink(link: String)
    case pasteLink
    case scanQRCode
    case createGroup

    var id: String {
        switch self {
        case let .createLink(link): return "createLink \(link)"
        case .pasteLink: return "pasteLink"
        case .scanQRCode: return "scanQRCode"
        case .createGroup: return "createGroup"
        }
    }
}

struct NewChatButton: View {
    @Binding var showAddChat: Bool
    @State private var actionSheet: NewChatAction?

    var body: some View {
        Button { showAddChat = true } label: {
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
        .confirmationDialog("Add contact to start a new chat", isPresented: $showAddChat, titleVisibility: .visible) {
            Button("Create one-time invitation link") { addContactAction() }
            Button("Paste received link") { actionSheet = .pasteLink }
            Button("Scan QR code") { actionSheet = .scanQRCode }
            Button("Create secret group") { actionSheet = .createGroup }
        }
        .sheet(item: $actionSheet) { sheet in
            switch sheet {
            case let .createLink(link):
                CreateLinkView(selection: .oneTime, connReqInvitation: link)
            case .pasteLink: PasteToConnectView()
            case .scanQRCode: ScanToConnectView()
            case .createGroup: AddGroupView()
            }
        }
    }

    func addContactAction() {
        Task {
            if let connReq = await apiAddContact() {
                actionSheet = .createLink(link: connReq)
            }
        }
    }
}

enum ConnReqType: Equatable {
    case contact
    case invitation
}

func connectViaLink(_ connectionLink: String, _ dismiss: DismissAction? = nil) {
    Task {
        if let connReqType = await apiConnect(connReq: connectionLink) {
            DispatchQueue.main.async {
                dismiss?()
                connectionReqSentAlert(connReqType)
            }
        } else {
            DispatchQueue.main.async {
                dismiss?()
            }
        }
    }
}

func connectionReqSentAlert(_ type: ConnReqType) {
    AlertManager.shared.showAlertMsg(
        title: "Connection request sent!",
        message: type == .contact
            ? "You will be connected when your connection request is accepted, please wait or check later!"
            : "You will be connected when your contact's device is online, please wait or check later!"
    )
}

struct NewChatButton_Previews: PreviewProvider {
    static var previews: some View {
        NewChatButton(showAddChat: Binding.constant(false))
    }
}
