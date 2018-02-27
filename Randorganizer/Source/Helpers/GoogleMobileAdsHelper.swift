//
//  GoogleMobileAdsHelper.swift
//  Randorganizer
//
//  Created by Christopher Luu on 2/18/18.
//

import Foundation
import GoogleMobileAds

struct GoogleMobileAdsHelper {
	static func setUp() {
		GADMobileAds.configure(withApplicationID: Secrets.googleAdMobAppId)
	}

	// MARK: - Initializations -
	private init() { }
}
