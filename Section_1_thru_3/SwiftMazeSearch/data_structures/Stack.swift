//
//  Stack.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

/**
    A stack that uses a doubly linked list to store and retrieve its contents.
 
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
public class Stack<T: Equatable>: CustomStringConvertible, Sequence, Equatable {
    
    /// The number of nodes in the stack.
    public var numberOfNodes: Int { return list.numberOfNodes }
    
    /// `true` if the stack is empty, `false` if it is not.
    public var isEmpty: Bool { return list.isEmpty }
    
    /**
        A textual representation of this stack.
     
        - important:
        Note that generating this string is an O(N) operation because we need to iterate through all
        the elements in the stack in order to generate this string.
    */
    public var description: String { return list.description }

    /// The linked list that is used behind the scenes to store and retrieve the elements in the stack.
    private let list: LinkedList<T>
    
    /// Creates an empty stack.
    public convenience init() {
        self.init(LinkedList<T>())
    }
    
    /**
        A copy initializer.
     
        - parameter stack: the stack to copy.
     */
    public convenience init(_ stack: Stack<T>) {
        self.init(LinkedList<T>(stack.list))
    }
    
    /**
        An initializer that takes in a linked list, and assigns it to the `stack` property of this class.
     
        - parameter list: the linked list that will be used by this queue to store and retrieve the queue's contents.
     */
    private init(_ list: LinkedList<T>) {
        self.list = list
    }
    
    /**
        Pushes a new element onto the stack.
     
        - parameter element: the element to push onto the stack.
    */
    func push(_ element: T) {
        list.addToTail(element)
    }
    
    /**
        Removes and returns the element at the top of the stack.
     
        - returns: the element, if any, that was poppsed from the stack.
    */
    func pop() -> T? {
        return list.removeTail()
    }
    
    /**
        Returns _without returning_ the element at the top of the stack.
    */
    func peek() -> T? {
        return list.peekTail()
    }
    
    /**
        Checks if an element is in the stack.
     
        - parameter element: the element to search for.
        - returns: `true` if the element is in the stack, `false` if it is not.
    */
    func contains(_ element: T) -> Bool {
        return list.contains(element)
    }
    
    /**
        Removes all elements from this stack.
        - important: this is an O(1) operation.
     */
    public func clear() {
        list.clear()
    }
    
    /**
        Compares the elements of two `Stack` objects and checks _all_ the elements one-by-one
        to see if they are equal to each other.
     
        - parameter left:  the `Stack` object on the left side of the `==` operator.
        - parameter right: the `Stack` object on the right side of the `==` operator.
        - returns: `true` if `left` and `right` contain the same number of nodes _and_ contains the
        same elements in the same order, `false` otherwise.
     */
    public static func ==<T: Equatable>(left: Stack<T>, right: Stack<T>) -> Bool {
        return left.list == right.list
    }
    
    public typealias StackIterator = LinkedListReverseIterator<T>
    
    /**
        Returns an iterator over the elements of this sequence that starts at the head of the stack and ends at the tail
        (i.e., the order in which this iterator will iterate over the elements in this stack is the same order in which they
        can be popped)
     
        Complexity: O(1).
     */
    public func makeIterator() -> StackIterator {
        return list.makeReverseIterator()
    }
    
    /**
        Makes and returns an array containing the contents of this stack in the order in which they would be popped.
     
        - returns: an array containing the contents of this stack.
    */
    public func toArray() -> [T] {
        return list.toArrayReverse()
    }
}
