//
//  CIEventView.swift
//  SimpleX (iOS)
//
//  Created by JRoberts on 20.07.2022.
//  Copyright © 2022 SimpleX Chat. All rights reserved.
//

import SwiftUI
import SimpleXChat

struct CIEventView: View {
    var chatItem: ChatItem

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if let member = chatItem.memberDisplayName {
                Text(member)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontWeight(.light)
                + Text(" ")
                + eventText()
            } else {
                eventText()
            }
        }
        .padding(.leading, 6)
        .padding(.bottom, 6)
        .textSelection(.disabled)
    }

    func eventText() -> Text {
        Text(chatItem.content.text)
            .font(.caption)
            .foregroundColor(.secondary)
            .fontWeight(.light)
        + Text(" ")
        + chatItem.timestampText
            .font(.caption)
            .foregroundColor(Color.secondary)
            .fontWeight(.light)
    }
}

struct CIEventView_Previews: PreviewProvider {
    static var previews: some View {
        CIEventView(chatItem: ChatItem.getGroupEventSample())
    }
}
