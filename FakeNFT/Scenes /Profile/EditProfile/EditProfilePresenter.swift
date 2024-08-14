//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 11/08/2024.
//

import Foundation

protocol EditProfilePresenterProtocol: AnyObject {
    func setup()
}

final class EditProfilePresenter: EditProfilePresenterProtocol {

    // MARK: - Properties

    typealias Section = EditProfileScreenModel.TableData.Section

    private weak var view: EditProfileViewProtocol?
    private var profileService: ProfileServiceProtocol?
    private var profile: ProfileModel

    init(view: EditProfileViewProtocol, profileService: ProfileServiceProtocol, profile: ProfileModel) {
        self.view = view
        self.profileService = profileService
        self.profile = profile
    }

    // MARK: - Private methods

    private func render(reloadData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadTableData: true)
    }

    private func buildScreenModel() -> EditProfileScreenModel {
        return EditProfileScreenModel(image: profile.avatar, tableData: EditProfileScreenModel.TableData(
            sections: [
                generateNameSection(),
                generateDescriptionSection(),
                generateSiteSection()
            ])
        )
    }

    private func generateNameSection() -> Section {
        .headeredSection(header: "Имя",
                         cells: [
                            .textViewCell(TextViewCellModel(
                                text: profile.name,
                                textDidChanged: { [ weak self ] name in
                                    guard let self else { return }
                                    DispatchQueue.global().sync {
                                        self.profile.name = name
                                    }
                                }))
                         ])
    }

    private func generateDescriptionSection() -> Section {
        .headeredSection(
            header: "Описание",
            cells: [
                .textViewCell(
                    TextViewCellModel(
                        text: profile.description,
                        textDidChanged: { [weak self] description in
                            guard let self else { return }
                            DispatchQueue.global().sync {
                                self.profile.description = description
                            }
                        }
                    )
                )
            ]
        )
    }

    private func generateSiteSection() -> Section {
        .headeredSection(header: "Сайт",
                         cells: [
                            .textViewCell(TextViewCellModel(
                                text: profile.website,
                                textDidChanged: { [ weak self ] website in
                                    guard let self else { return }
                                    DispatchQueue.global().sync {
                                        self.profile.website = website
                                    }
                                }))
                         ])
    }

    private func updateProfileInfo(profile: ProfileModel) {
        profileService?.updateProfile(profile: profile, completion: { result in
            switch result {
            case let .success(profile):
                print("profile info successfully updated")
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }

    // MARK: - Public methods

    func setup() {
        render()
    }

    func saveChanges() {
        updateProfileInfo(profile: profile)
    }
}
