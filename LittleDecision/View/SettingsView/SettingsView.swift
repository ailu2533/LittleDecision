//
//  SettingsView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/9.
//

import Defaults
import LemonViews
import RevenueCat
import RevenueCatUI
import SwiftUI
import UniformTypeIdentifiers

// let emailAddress = "im.ailu@outlook.com"

// MARK: - SettingsView

struct SettingsView: View {
    @Default(.noRepeat) private var noRepeat
    @Default(.equalWeight) private var equalWeight
    @Default(.rotationTime) private var rotationTime
//    @Default(.fontSize) private var fontSize
    @Default(.enableSound) private var enableSound

    @Environment(\.openURL) var openURL

    @Environment(SubscriptionViewModel.self)
    private var subscriptionViewModel

    @Environment(GlobalViewModel.self)
    private var globalViewModel

    @State private var showPaywall = false
    @State private var backupDocument = DecisionBackupDocument.empty
    @State private var showExportFileExporter = false
    @State private var showImportFileImporter = false
    @State private var isImportingBackup = false
    @State private var showBackupAlert = false
    @State private var backupAlertTitle = ""
    @State private var backupAlertMessage = ""

//    @State private var isPremium = false

    var body: some View {
        NavigationStack {
            Form {
                Button(action: {
                    showPaywall = true
                }, label: {
                    PremiumView(isPremium: subscriptionViewModel.canAccessContent)
                })
                .buttonStyle(PlainButtonStyle())
                .listRowBackground(Color.clear)
                .listRowInsets(.zero)

                settingsSection

                dataSection

                contactSection
            }
//            .settingsBackground()
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showPaywall, content: {
                PaywallView(displayCloseButton: true)
            })
            .fileExporter(
                isPresented: $showExportFileExporter,
                document: backupDocument,
                contentType: .json,
                defaultFilename: "LittleDecision-Backup",
                onCompletion: handleExportCompletion
            )
            .fileImporter(
                isPresented: $showImportFileImporter,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false,
                onCompletion: handleImportCompletion,
                onCancellation: {}
            )
            .alert(backupAlertTitle, isPresented: $showBackupAlert) {
                Button("好", role: .cancel) {}
            } message: {
                Text(backupAlertMessage)
            }
        }
    }

    @ViewBuilder
    private var settingsSection: some View {
        Section {
            Toggle(isOn: $noRepeat) {
                Label {
                    VStack(alignment: .leading) {
                        Text("不重复抽取")
                        Text("已经被抽中的选项不会被抽中")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }

                } icon: {
                    Image(systemSymbol: .repeat)
                }
                .labelStyle(SettingsLabelStyle(backgroundColor: .cyan))
            }

            Toggle(isOn: $equalWeight) {
                Label {
                    VStack(alignment: .leading) {
                        Text("等概率抽取")
                        Text("抽取时忽略选项的权重")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }

                } icon: {
                    Image(systemSymbol: .equalSquare)
                }
                .labelStyle(SettingsLabelStyle(backgroundColor: .cyan))
            }

            Toggle(isOn: $enableSound) {
                Label {
                    Text("声音")
                } icon: {
                    Image(systemSymbol: .speakerWave3)
                }
                .labelStyle(SettingsLabelStyle(backgroundColor: .cyan))
            }

            rotationTimePicker
        }.onChange(of: noRepeat) { _, newValue in
            globalViewModel.send(.userDefaultsNoRepeat(newValue))
        }.onChange(of: equalWeight) { _, newValue in
            globalViewModel.send(.userDefaultsEqualWeight(newValue))
        }
    }

    private var contactSection: some View {
        ContactSection()
    }

    private var dataSection: some View {
        Section {
            Button(action: exportBackup) {
                Label("导出数据", systemImage: "square.and.arrow.up")
                    .labelStyle(SettingsLabelStyle(backgroundColor: .cyan))

            }

            Button(action: {
                showImportFileImporter = true
            }, label: {
                HStack(spacing: 8) {
                    Label("导入数据", systemImage: "square.and.arrow.down")
                        .labelStyle(SettingsLabelStyle(backgroundColor: .cyan))

                    if isImportingBackup {
                        ProgressView()
                            .controlSize(.small)
                    }
                }

            })
            .disabled(isImportingBackup)
        }
    }

    private var rotationTimePicker: some View {
        Picker(selection: $rotationTime) {
            ForEach([2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0], id: \.self) { duration in
                Text("\(Int(duration))秒").tag(duration)
            }
        } label: {
            Label("转盘旋转时长", systemSymbol: .stopwatch)
                .labelStyle(SettingsLabelStyle(backgroundColor: .cyan))
        }
    }

    private func exportBackup() {
        do {
            let document = try DecisionBackupStore.makeExportDocument(from: globalViewModel.modelContext)
            _ = try DecisionBackupStore.writeExportDocumentToDocuments(document)

            backupDocument = document
            showExportFileExporter = true
        } catch {
            presentBackupAlert(title: "导出失败", message: error.localizedDescription)
        }
    }

    private func handleExportCompletion(_ result: Result<URL, Error>) {
        if case let .failure(error) = result {
            presentBackupAlert(title: "导出失败", message: error.localizedDescription)
        }
    }

    private func handleImportCompletion(_ result: Result<[URL], Error>) {
        switch result {
        case let .success(urls):
            guard let url = urls.first else {
                presentBackupAlert(title: "导入失败", message: "未找到可导入的文件。")
                return
            }

            isImportingBackup = true
            showImportFileImporter = false

            Task { @MainActor in
                await Task.yield()
                do {
                    try DecisionBackupStore.importBackup(from: url, into: globalViewModel.modelContext)
                    globalViewModel.send(.decisionUUID(Defaults[.decisionID]))
                    isImportingBackup = false
                    presentBackupAlert(title: "导入完成", message: "已成功导入并合并数据。")
                } catch {
                    isImportingBackup = false
                    presentBackupAlert(title: "导入失败", message: error.localizedDescription)
                }
            }
        case let .failure(error):
            presentBackupAlert(title: "导入失败", message: error.localizedDescription)
        }
    }

    private func presentBackupAlert(title: String, message: String) {
        backupAlertTitle = title
        backupAlertMessage = message
        showBackupAlert = true
    }
}
