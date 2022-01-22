//
//  CommonViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import Foundation
import Moya

class CommonViewModel {

    let provider: MoyaProvider<SLPTarget>
    init() { provider = MoyaProvider<SLPTarget>() }
}

extension CommonViewModel {

    func process<T: Codable, E>(
        type: T.Type,
        result: Result<Response, MoyaError>,
        completion: @escaping (Result<E, Error>) -> Void
    ) {
        switch result {
        case .success(let response):
            completion(.success(response.statusCode as! E))
        case .failure(let error):
            completion(.failure(error))
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
            completion(.failure(error))
        }
    }
}
