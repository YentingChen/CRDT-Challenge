//
//  LWWGSet.swift
//  State-based LWW-Element-Graph
//
//  Created by Yenting Chen on 2021/9/1.
//

import Foundation

///A  LWWGSet is a Grow-only set, which stores the time each element was added
struct LWWGSet<T: Hashable>: Hashable {
    
    /// A dictionary that stores the time an element was added.
    var dataWithTime = [T : Date]()
    
    /// Returns the time `item` was added to this set, if it was added.
    ///
    /// - Parameter item: The item to look up.
    /// - Returns: The time `item` was added or nil.
    func lookup(_ item: T) -> Date? {

        return dataWithTime[item]
        
    }
    
    /// Adds an item to this set.
    ///
    /// - Parameters:
    ///   - item: The item to add to this set.
    ///   - timestamp: The time at which `item` was added into this set. If not provided, defaults to the current system date/time.
    mutating func add(_ item: T, timestamp: Date = Date()) {
        
        if let previousAddTime = lookup(item), previousAddTime >= timestamp {
            
            return
            
        }
        
        dataWithTime[item] = timestamp
    }
    
    /// Merges another set into this set, selecting the later timestamp if there are multiple for the same element.
    ///
    /// - Parameter anotherSet: The set to merge into this set.
    mutating func merge(anotherSet: LWWGSet<T>) -> LWWGSet<T> {
        
        for i in anotherSet.dataWithTime {
            
            if let value = dataWithTime[i.key] {
                
                dataWithTime[i.key] = max(value, i.value)
                
            } else {
        
                dataWithTime[i.key] = i.value
            }
            
        }
        
        return LWWGSet(dataWithTime: dataWithTime)
        
    }
    
}
