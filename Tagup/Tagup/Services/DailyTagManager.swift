//
//  DailyTagManager.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 23/03/25.
//

import Foundation

class DailyWordManager {
    static let shared = DailyWordManager()
    
    private let referenceDate: Date = {
        var components = DateComponents()
        components.year = 2025
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    private let words: [String] = [
        "apple", "chair", "river", "mountain", "bottle", "window", "clock", "garden", "mirror", "pencil",
        "candle", "bridge", "ladder", "shadow", "thunder", "whisper", "breeze", "ocean", "pocket", "lantern",
        "blanket", "suitcase", "horizon", "feather", "compass", "notebook", "jellyfish", "emerald", "bicycle", "perfume",
        "diamond", "chimney", "sunrise", "waterfall", "treasure", "volcano", "sapphire", "umbrella", "keyboard", "sunset",
        "hammock", "dolphin", "pumpkin", "telescope", "butterfly", "chocolate", "lightning", "festival", "curtain", "necklace",
        "library", "meadow", "rainbow", "teapot", "carousel", "cobweb", "lantern", "vineyard", "compass", "gemstone",
        "elevator", "meadow", "sunflower", "aquarium", "tapestry", "postcard", "orchestra", "backpack", "valley", "moonlight",
        "igloo", "labyrinth", "lemonade", "fireplace", "cuckoo", "glacier", "dragonfly", "parchment", "seahorse", "bracelet",
        "mirage", "cathedral", "violin", "whisper", "zephyr", "thunderstorm", "amulet", "parchment", "locket", "mosaic",
        "sculpture", "harpoon", "panther", "velvet", "avalanche", "clover", "labyrinth", "trinket", "zephyr", "snowflake",
        "frostbite", "gondola", "pumpkin", "topaz", "bonfire", "basilisk", "cauldron", "centaur", "potion", "enigma",
        "silhouette", "clockwork", "masquerade", "nightfall", "trellis", "cobblestone", "icicle", "shadow", "postcard", "chandelier",
        "meadow", "carousel", "valley", "bracelet", "sapphire", "tapestry", "snowflake", "sunflower", "cathedral", "gemstone",
        "silhouette", "shadow", "parchment", "masquerade", "trinket", "lantern", "icicle", "whisper", "bonfire", "carousel",
        "rainbow", "telescope", "moonbeam", "festival", "topaz", "sculpture", "mirage", "postcard", "parchment", "labyrinth",
        "dragonfly", "pumpkin", "chandelier", "gemstone", "snowflake", "shadow", "cathedral", "trinket", "parchment", "meadow",
        "hammock", "valley", "cobblestone", "clockwork", "bonfire", "silhouette", "moonbeam", "potion", "masquerade", "topaz",
        "meadow", "chandelier", "parchment", "postcard", "bracelet", "snowflake", "rainbow", "labyrinth", "carousel", "telescope",
        "hammock", "festival", "clockwork", "trinket", "icicle", "bonfire", "gemstone", "mirage", "rainbow", "moonbeam",
        "carousel", "silhouette", "valley", "shadow", "cathedral", "sunflower", "chocolate", "cuckoo", "clockwork", "gondola"
    ]

    func fetchDailyWord() -> String {
        let currentDay = Calendar.current.dateComponents([.day], from: referenceDate, to: Date()).day ?? 0
        print("Days since reference:", currentDay)
        print("Today's Date:", Date())
        return words[currentDay % words.count]
    }
}
