//
//  Queue.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

/**
    A queue that uses a doubly linked list to store and retrieve its contents.
 
    - Author:
    Andrew Huber
 
    - Version 
    1.0
 
    - remark:
    The abstract data type `T` must conform to the protocol `Equatable` in order to perform linear searches for an element
    in the following functions:
 
    - `public func contains(_ element: T) -> Bool`
    - `public static func ==<T: Equatable>(left: Queue<T>, right: Queue<T>) -> Bool`
*/
public class Queue<T: Equatable>: CustomStringConvertible, Sequence, Equatable {
    
    /// The linked list that is used behind the scenes to store and retrieve the elements in the queue.
    private let list: LinkedList<T>
    
    /// The number of nodes in the queue.
    public var numberOfNodes:Int { return list.numberOfNodes }
    
    /// `true` if there is nothing stored in the queue, `false` if there _is_ something stored in the queue.
    public var isEmpty: Bool { return list.isEmpty }
    
    /**
        A textual representation of this queue.
    
        - important:
        Note that generating this string is an O(N) operation because we need to iterate through all
        the elements in the queue in order to generate this string.
     */
    public var description: String { return list.description }
    
    /// Creates an empty queue
    public convenience init() {
        self.init(LinkedList<T>())
    }
    
    /**
        A copy initializer.
     
        - parameter queue: the queue to copy.
    */
    public convenience init(_ queue: Queue<T>) {
        self.init(LinkedList<T>(queue.list))
    }
    
    /**
        An initializer that takes in a linked list, and assigns it to the `queue` property of this class.
     
        - parameter list: the linked list that will be used by this queue to store and retrieve the queue's contents.
    */
    private init(_ list: LinkedList<T>) {
        self.list = list
    }
    
    /**
        Adds a new element to the queue.
     
        - parameter element: the new element to add to the queue.
    */
    public func enqueue(_ element: T) {
        list.addToTail(element)
    }
    
    /**
        Removes an element from the queue.
     
        - returns: the element that was removed from the queue, if any.
    */
    public func dequeue() -> T? {
        return list.removeHead()
    }
    
    /**
        Retrieves the element at the head of the queue _without_ removing it.
     
        - returns: the element stored at the head of the queue, if any.
    */
    public func peek() -> T? {
        return list.peekHead()
    }
    
    /**
     This function iterates through each element in this queue, and applies an operation
     to the element. Then, the results of those operations are stored in another queue;
     the elements in the second queue correspond to the elements in _this_ queue.
     
     For example, if you have a queue storing the names of people waiting to be served at Starbucks, you
     can transform their full names to their first names as follows.
     
            // Type inference should be used here, but we
            // explicitly defined the type here for added 
            // clarity in this explanation.
            let starbucksQueue: Queue<FullName> = getNames()
            var counter = 1
     
            // Type inference should be used here as well,
            // but we explicitly defined the type here for
            // added clarity in this explanation.
            let names: Queue<String> = starbucksQueue.map(
            { name in
                let newElement = 
                    "\(counter). \(name.firstName) " +
                    "\(name.lastName)"
                counter += 1
                return newElement
            } )
     
            if names.numberOfNodes == 0 {
                print("There is no one in the queue")
            }
            else if names.numberOfNodes == 1 {
                print("There is 1 person in the queue")
            }
            else {
                print("There are \(names.numberOfNodes) " +
                    "people in the queue")
            }
     
            while !names.isEmpty {
                print(names.dequeue())
            }
     
     - parameter mappingFunction: a function that takes in an element in _this_ queue and returns what
       should be stored in the second queue (see example above for more information).
     
     - returns: another queue with the transformed data (i.e., the "second queue")
     */
    public func map<U: Equatable>(_ mappingFunction: (T) -> U) -> Queue<U> {
        return Queue<U>(list.map(mappingFunction))
    }
    
    /**
        Checks to see if a certain element is in the queue.
     
        - parameter element: the element to look for.
        - returns: `true` if `element` is in the linked list, `false` if it is not.
     */
    public func contains(_ element: T) -> Bool {
        return list.contains(element)
    }
    
    /**
     Removes all elements from this queue.
     - important: this is an O(1) operation.
     */
    public func clear() {
        list.clear()
    }
    
    public typealias QueueIterator = LinkedListIterator<T>
    
    /**
        Returns an iterator over the elements of this sequence that starts at the head of the queue and ends at the tail
        (i.e., the order in which this iterator will iterate over the elements in this queue is the same order in which they
        can be dequeued) 
     
        Complexity: O(1).
     */
    public func makeIterator() -> QueueIterator {
        return list.makeIterator()
    }
    
    /**
        Compares the elements of two `Queue` objects and checks _all_ the elements one-by-one
        to see if they are equal to each other.
     
        - parameter left:  the `Queue` object on the left side of the `==` operator.
        - parameter right: the `Queue` object on the right side of the `==` operator.
        - returns: `true` if `left` and `right` contain the same number of nodes _and_ contains the
        same elements in the same order, `false` otherwise.
     */
    public static func==<T: Equatable>(left: Queue<T>, right: Queue<T>) -> Bool {
        return left.list == right.list
    }
    
    /**
        Makes and returns an array containing the contents of this queue in the order in which they would be dequeued.
     
        - returns: an array containing the contents of this queue.
     */
    public func toArray() -> [T] {
        return list.toArray()
    }
}
