//
//  CommonViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import Foundation
import FirebaseAuth
import Moya

class CommonViewModel {

    let provider: MoyaProvider<SLPTarget>
    init() { provider = MoyaProvider<SLPTarget>() }
}

extension CommonViewModel {

    func process<T: Codable, E>(
        type: T.Type,
        result: Result<Response, MoyaError>,
        completion: @escaping (Result<E, DefaultMoyaNetworkServiceError>) -> Void
    ) {
        switch result {
        case .success(let response):
            let data = try? JSONDecoder().decode(type, from: response.data)
            completion(.success(data as! E))
        case .failure(let error):
            completion(.failure(DefaultMoyaNetworkServiceError(rawValue: error.response!.statusCode) ?? .unknown))
        }
    }

    func process(
        result: Result<Response, MoyaError>,
        completion: @escaping (Result<Int, Error>) -> Void
    ) {
        switch result {
        case .success(let response):
            completion(.success(response.statusCode))
        case .failure(let error):
            completion(.failure(DefaultMoyaNetworkServiceError(rawValue: error.response!.statusCode) ?? .unknown))
        }
    }

    func requestFirebaseIdtoken(completion: @escaping () -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            //print(idToken! + "이거")
            UserDefaults.standard.setValue(idToken!, forKey: "IdToken")
            completion()
        }
    }
}
