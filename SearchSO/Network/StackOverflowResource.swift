//
//  StackOverflowResource.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import Foundation

struct StackOverflowResource<A> {
    let url: URL
    let parse: (Data) -> A?
}
