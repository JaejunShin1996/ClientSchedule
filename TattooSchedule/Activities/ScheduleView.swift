//
//  ScheduleView.swift
//  TattooSchedule
//
//  Created by Jaejun Shin on 14/6/2022.
//

import BackgroundTasks
import SwiftUI

struct ScheduleView: View {
    @Environment(\.scenePhase) var scenePhase
    @SceneStorage("selectedView") var selectedView: String?

    @StateObject var viewModel: ViewModel
    @EnvironmentObject var dataController: DataController

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)

        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        TabView(selection: $selectedView) {
            TodaySectionView(viewModel: viewModel, dataController: dataController)
                .tag(TodaySectionView.tag)
                .tabItem {
                    Image(systemName: "clock")
                    Text("Today")
                }

            UpcomingSectionView(viewModel: viewModel, dataController: dataController)
                .tag(UpcomingSectionView.tag)
                .tabItem {
                    Image(systemName: "hourglass")
                    Text("Upcoming")
                }

            PastSectionView(viewModel: viewModel, dataController: dataController)
                .tag(PastSectionView.tag)
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Past")
                }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                print("Inactive")
                viewModel.reload()
            } else if newPhase == .active {
                print("Active")
                viewModel.reload()
            } else if newPhase == .background {
                print("Background")
                viewModel.reload()
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(dataController: DataController.preview)
    }
}
