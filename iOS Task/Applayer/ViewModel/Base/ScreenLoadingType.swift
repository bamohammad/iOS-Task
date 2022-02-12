//
//  ScreenLoadingType.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 8/7/20.
//  Copyright © 2020 Tuan Truong. All rights reserved.
/// this class is pre defined and we modify it to match our requierments

public enum ScreenLoadingType<Input> {
    case loading(Input)
    case reloading(Input)
}
