//
//  RedBlackTree.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

/**
    A red black tree.
 
    - Author:
    Andrew Huber
 
    - Version
    1.0
 
    - remark:
    The abstract data type `T` must conform to the following protocols:
 
        - `T` must conform to the protocol `Comparable` in order to maintain the properties
          of a binary search tree (all nodes to the left of a node `N` is less than `N` and 
          all nodes to the right of `N` are greater than `N`)
        - `T` must also conform to the protocol `CustomStringConvertible` in order to get a 
          textual representation of this red black tree.
 */
public class RedBlackTree<T>: CustomStringConvertible where T: Comparable, T: CustomStringConvertible {
    
    /// `true` if it is empty (contains zero nodes), `false` otherwise.
    public var isEmpty: Bool { return numberOfNodes == 0 }
    
    /// The number of nodes stored in this red black tree.
    public var numberOfNodes: Int { return numNodes }
    
    /// A value of type `RedBlackTreeTextualRepresentationType` describing how this red black tree should
    /// be represented textually. For more information, view the documentation on the `description` property
    /// of this class.
    public var textualRepresentationType: RedBlackTreeTextualRepresentationType
    
    /**
        A textual representation of this stack or the word `Empty` if the red black tree is empty.
     
        - important:
            - Generating this string is an O(N) operation because an in-order traversal is performed.
     
            - Also note that this string will list the parent, left, and right node along with the color of
              the current node if `textualRepresentationType` is `RedBlackTreeTextualRepresentationType.descriptive`
              for _each_ node. Due to this added information, this string will contain multiple lines of text in order 
              to make this information readable.
     
            - If `textualRepresentationType` is `RedBlackTreeTextualRepresentationType.succinct`, then 
              the items in the red black tree are listed in the common `[A, B, C, D, ..., Z]` format.
     */
    public var description: String {
        
        var string = ""
        
        if isEmpty {
            string = "Empty"
        }
        else if textualRepresentationType == .descriptive {
            traverse(traversalType: .inOrder, onNodeTouched: { (contents: NodeContents<T>) -> () in
                string += "\(contents)\n\n"
            })
        }
        else {
            var numberOfNodesTraversed = 0
            
            traverse(traversalType: .inOrder, onNodeTouched: { (contents: NodeContents<T>) -> () in
                if numberOfNodesTraversed == 0 {
                    string += "["
                }
                
                string += "\(contents.nodeContents)"
                
                if numberOfNodesTraversed == numberOfNodes - 1 {
                    string += "]"
                }
                else {
                    string += ", "
                }
                
                numberOfNodesTraversed += 1
            } )
        }
        
        return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// The root of the red black tree.
    private var root: Node<T>? = nil
    
    /// The number of nodes in the red black tree.
    private var numNodes = 0
    
    /**
        Creates an empty red black tree.
     
        This initializer one to specify whether or not they wish to have a descriptive
        or succinct textual representation of this red black tree. 
     
        If you do not care about what kind of information is presented in the textual representation 
        of this red black tree so long as you can see its contents, we recommend using 
        `public convenience init()` rather than this initializer.
     
        For more information on how the red black tree is represented as a String, please view the 
        documentation on the `description` property of this class.
     
     - parameter textualRepresentationType: a value of type `RedBlackTreeTextualRepresentationType` 
                                            describing how this red black tree should be represented 
                                            textually.
     
        - important:
        You may set `textualRepresentationType` to a different value later.
    */
    public init (textualRepresentationType: RedBlackTreeTextualRepresentationType) {
        self.textualRepresentationType = textualRepresentationType
    }
    
    /**
        Creates an empty red black tree.
     
        This initializer does _not_ allow you to specify whether or not you wish to have a descriptive
        or succinct textual representation of this red black tree because this initializer sets this
        class's `textualRepresentationType` property to `RedBlackTreeTextualRepresentationType.succinct`.
     
        If you wish to set `textualRepresentationType` to `RedBlackTreeTextualRepresentationType.descriptive`,
        we recommend using `public init (textualRepresentationType: RedBlackTreeTextualRepresentationType)`.
     
        For more information on how the red black tree is represented as a String, please view the
        documentation on the `description` property of this class.
     
        - important: 
        You may set `textualRepresentationType` to a different value later.
    */
    public convenience init() {
        self.init(textualRepresentationType: .succinct)
    }
    
    /**
     Inserts a new item into the Red Black Tree.
     
     - parameter data: the data to insert into the Red Black Tree
     - returns: `true` if `data` was successfully inserted into the Red Black Tree, `false` if it already exists in the tree.
     */
    func insert(_ data: T) -> Bool {
        return insert(data: data, node: root, parent: nil)
    }
    
    /**
     Performs the work necessary to insert a new item into the red black tree.
     
     # Insert Cases
     In order to ensure that an insertion into the red black tree does not affect any of the
     five properties of a red black tree, there are five insertion cases that the code needs
     to take into consideration in order to check the tree and correct it if necessary.
     
     ## Properties of a Red Black Tree
     In each of the insertion cases, references are made to the properties of a red black
     tree. Let us briefly recap the properties of a red black tree as mentioned on 
     [Wikipedia's page on Red Black Trees](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree).
     
     1. Each node is either red or black.
     2. The root is black. This rule is sometimes omitted. Since the root can always be changed from red to
     black, but not necessarily vice versa, this rule has little effect on analysis.
     3. All leaves (`NIL`) are black.
     4. If a node is red, then both of its children are black.
     5. Every path from a given node to any of its descendant `NIL` nodes contains the same number of black
     nodes. With this said, there are a few useful definitions:
        * **Black depth** is the number of black nodes from the root to a node
        * **Black height** is the uniform number of black nodes in all paths from the root to the leaves.
     
     ## Properties That Do Not Need Constant Explanation
     For the `insertCase1`, `insertCase2`, ..., `insertCase5` functions, each case is
     explained, and which properties of a red black tree hold and do not hold are explained.
     However, two properties are omitted because they are unnecessary.
     
     - **Property 1** will always hold because beause in every insertion case, the node will
     either be black or red from the start, and each node _may_ be recolored either red
     or black.
     
     - **Property 3** will always hold because our code will consider all leaves as black,
     _always_.
     
     It is also important to remember that, in a red black tree, _all_ newly inserted nodes 
     are red at first.
     
     - parameters:
        - data: the data to insert into the red black tree.
        - nodeOp: the current node we are at in the tree or `nil` if there are no nodes in the tree.
        - parentOp: `nodeOp`'s parent.
     
     - returns: `true` if `data` was successfully inserted into the Red Black Tree, `false` if it already exists in the tree.
    */
    private func insert(data: T, node nodeOp: Node<T>?, parent parentOp: Node<T>?) -> Bool {
        // If we have to keep going down the tree (i.e., if there is a node)
        if let node = nodeOp {
            if let nodeData = node.data {
                if data < nodeData {
                    return insert(data: data, node: node.left, parent: node)
                }
                else if data > nodeData {
                    return insert(data: data, node: node.right, parent: node)
                }
                else {
                    return false // data already exists in the tree
                }
            }
            else {
                node.unnullify(withThisStoredInTheNode: data, andThisAsItsParent: parentOp)
                insertCase1(node)
            }
        }
        else {
            root = Node<T>(data: data)
            insertCase1(root!)
        }
        
        numNodes += 1
        return true
    }
    
    /**
        The first of five insert cases that must be analyzed in order to maintain the properties of a
        red black tree during an insertion.
     
        - note:
            In this case, `node` is repainted black if it is the root.
     
            - **Property 2** holds because `node` is repainted black if it is the root. If `node` is
            not the root, then its color is left alone.
        
            - If `node` is the only node in the tree, then **Property 4** still holds because
            there will be no red nodes in the tree. Otherwise, this function will go to 
            `insertCase2`, and possibly `insertCase3`, `insertCase4`, or `insertCase5`, and 
            one of those functions will correct this property.
     
            - Even if the root _was_ red and is _now_ black, the number of nodes from any given node
            (in this instance, the root, to all leaf nodes is _still_ the same; we just increased
            that number by one. Therefore, **Property 5** still holds.
     
        - parameter node: the node to be analyzed.
        - postcondition: the tree will comply with all 5 properties of a red black tree.
    */
    private func insertCase1(_ node: Node<T>) {
        if node.parent == nil {
            node.color = .black // color the root black
        }
        else {
            insertCase2(node)
        }
    }
    
    /**
        The second of five insert cases that must be analyzed in order to maintain the properties of a
        red black tree during an insertion.
     
        - note:
            In this insertion case, it checks for if `node.parent` is black. If it is, we
            exit this function. Otherwise, we move on to the third insertion case.
     
            - It is possible that `node.parent` is the root of the tree, but because this
            insertion case immediately returns if `node.parent` is black, **Property 2** still
            holds. If `node.parent` is _not_ the root of the tree, then **Property 2** is not 
            threatened.
     
            - Regardless of the color of `node.parent`, `node` is still red because it is 
            either a newly-inserted node, which is always red, or a red node passed in by 
            another insertion case. Therefore, if `node.parent` is black, then we do not care 
            about the color of `node`, which is this function immediately returns in that case.
            However, if `node.parent` is red, then we need to move onto the third insertion 
            case to see if **Property 4** still holds.
     
            - If `node.parent` is black, then the number of nodes from `node.parent` to any of its
            descendant nodes has not changed because `node` is red. However, if `node.parent` 
            is red, then we need to see if **Property 5** still holds, and move onto the third 
            insertion case.
     
        - parameter node: the node to be analyzed.
        - precondition: `node` must have a parent, and `node` is red.
        - postcondition: the tree will comply with all 5 properties of a red black tree.
     */
    private func insertCase2(_ node: Node<T>) {
        assert(node.parent != nil)
        
        if node.parent!.color == .black {
            return // tree is still valid
        }
        else {
            insertCase3(node)
        }
    }
    
    /**
        The third of five insert cases that must be analyzed in order to maintain the properties of a
        red black tree during an insertion.
     
        - note:
            Because of Case 1, we have determined that `node` is _not_ the root of the tree,
            and because of the second insertion case, we have determined that `node.parent` is 
            red. If both the parent and uncle of `node` are red, then both of them will be
            repainted black and the grandparent of `node` becomes red; this is done to maintain
            Property 5. However, if this is not the case, then tree rotations need to be 
            performed, which are taken care of in the subsequent insertion cases.
     
            - The only way in which **Property 2** could be threatened is when we recolor the
            grandparent of `node` red. However, because we perform the entire procedure
            recursively on the grandparent from Case 1, the tree would be corrected if indeed
            the grandparent is the root of the whole tree.
     
            - We recolor the parent, uncle, and grandparent of `node` if the
            parent and uncle are red. This means that it is possible that the uncle of the
            _parent_ is red, which would be a violation of **Property 4**. In order to
            correct this, the entire procedure is recursively performed on the grandparent
            from Case 1. If the parent and uncle are not red, then it is still possible that
            this property is violated, but the tree is corrected by tree rotations, which
            are performed in the subsequent insertion cases.
     
            - **Property 5** is maintained by repainting the parent and uncle of `node` black 
            and the grandparent of `node` red if the parent and uncle are red. If this is the
            case, then the grandparent must be black because if it was red, then the parent
            could not also be red because it would violate Property 4. Since any path through
            the parent or uncle must pass through the grandparent, the number of black
            nodes on these paths has not changed, even after the recoloring. If the parent and 
            uncle are _not_ red, then tree rotations, which are performed in the following two
            insertion cases, will be performed to rebalance the tree.
     
        - parameter node: the node to be analyzed.
        - precondition: `node` must have a parent and it must be red
        - postcondition: the tree will comply with all 5 properties of a red black tree.
     */
    private func insertCase3(_ node: Node<T>) {
        assert(node.parent != nil)
        
        // If unc exists AND its color is Red
        if node.uncle?.color == .red {
            node.parent!.color = .black
            node.uncle!.color = .black
            node.grandparent!.color = .red
            insertCase1(node.grandparent!)
        }
        else {
            insertCase4(node)
        }
    }
    
    /**
        The fourth of five insert cases that must be analyzed in order to maintain the properties of a
        red black tree during an insertion.
     
        - note:
            Because of the first insertion case, we have determined that `node` is _not_ the
            root of the tree, because of the second insertion case, we have determined that 
            `node.parent` is red, and because of the third insertion case, we have determined
            that `node.parent` is red, but the uncle of `node` is black. In this case, we
            rebalance by
     
            A. performing a _right_ rotation if `node` is the _right_ child of `node.parent`
            and `node.parent` is the _left_ child of the grandparent, **OR**
     
            B. performing a _left_ rotation if `node` is the _left_ child of `node.parent` 
            and `node.parent` is the _right_ child of the grandparent.
     
            If A is true, `insertCase5` is called on `node.left`, if B is true, `insertCase5`
            is called on `node.right`, and if neither are true, then `insertCase5` is called
            on `node`.
     
            - If the grandparent of `node` is the root of the tree, then its color does not
            change as a result of the tree rotation, thereby not violating **Property 2**. 
            If the grandparent is not the root of the tree, then Property 2 is still not
            violated.
     
            - In this state, `node` (**N**) and `node.parent` (**P**) are both red. This is a
            violation of **Property 4**. Even if a tree rotation is performed, Property 4 is
            still violated because after the tree rotations, **P** becomes one of **N**'s
            children, and **P** and **N** are still red. These corrections are performed in
            `insertCase5`, which is called regardless of whether or not a tree rotation is 
            performed in this insertion case.
     
            -      
     
        - parameter node: the node to be analyzed.
        - precondition:
            _All_ of the following are true:
            - `node` must have a parent
            - the parent must be red
            - `node`'s uncle must be black
            - `node` must have a grandparent
        - postcondition: the tree will comply with all 5 properties of a red black tree.
     */
    private func insertCase4(_ node: Node<T>) {
        assert(node.parent != nil)
        assert(node.grandparent != nil)
        
        var node = node // makes node a variable, not a constant
        
        if (node == node.parent!.right) && (node.parent == node.grandparent!.left) {
            rotateLeft(node.parent!)
            node = node.left!
        }
        else if (node == node.parent!.left) && (node.parent == node.grandparent!.right) {
            rotateRight(node.parent!)
            node = node.right!
        }
        
        insertCase5(node)
    }
    
    /**
        The last of the five insert cases that must be analyzed in order to maintain the properties of a
        red black tree. For more information on this, please read `RedBlackTree_README.md`.
     
        - The rotation (shown below) causes some paths labeled in subtree "3" to not
        pass through the node `P` where they did before. This causes the imbalance in the
        black height to be corrected, and the tree to comply with **Property 5**.
     
         ```
                G                            P
              /   \                        /   \
            (P)    U                     (N)   (G)
           /  \   / \        === >      /  \   / \
          (N)   3 4   5                 1    2 3   U
          / \                                     / \
         1   2                                   4   5
         
         All nodes with parentheses are red nodes.
            All nodes without parentheses are black nodes.
                All numbered nodes are subtrees.
         ```
     
        - parameter node: the node to be analyzed.
        - precondition:
            - `node` must have a parent
            - the parent must be red
            - `node`'s uncle must be black
            - `node` must have a grandparent
        - postcondition: the tree will comply with all 5 properties of a red black tree.
     */
    private func insertCase5(_ node: Node<T>) {
        assert(node.parent != nil)
        assert(node.grandparent != nil)
        
        node.parent!.color = .black
        node.grandparent!.color = .red
        
        if node == node.parent!.left {
            rotateRight(node.grandparent!)
        }
        else {
            rotateLeft(node.grandparent!)
        }
    }
    
    func removeAll() {
        root = nil
        numNodes = 0
    }
    
    /**
     
     Removes an item from the Red Black Tree
     
     - parameters:
     - data: the data to remove
     
     - returns: the data that was removed or `nil` if it does not exist in the tree.
     
     */
    func remove(_ data: T) -> T? {
        if let returnData = remove(data: data, node: root) {
            numNodes -= 1
            return returnData
        }
        else {
            return nil
        }
    }
    
    private func remove(data: T, node nodeOp: Node<T>?) -> T? {
        if let node = nodeOp {
            // If we reached a null node
            if node.data == nil {
                return nil
            }
            // If we have to go left
            if data < node.data! {
                return remove(data: data, node: node.left)
            }
                // If we have to go right
            else if data > node.data! {
                return remove(data: data, node: node.right)
            }
                // If the node has TWO children
            else if node.hasLeftChild && node.hasRightChild {
                if let predecessor = inOrderPredecessor(ofNode: node) {
                    swapNodeData(node1: node, node2: predecessor)
                    return remove(data: data, node: predecessor)
                }
                else {
                    let successor = inOrderSuccessor(ofNode: node)!
                    swapNodeData(node1: node, node2: successor)
                    return remove(data: data, node: successor)
                }
            }
                // If the node has no more than one child
            else {
                let returnVal = node.data
                
                if node.color == .red {
                    // This can only occur when node has no children
                    node.nullify()
                }
                    // node.color must be black at this point
                else if node.child.color == .red {
                    replaceNode(node: node, child: node.child)
                    node.child.color = .black
                }
                else {
                    // The node is black and there are two leaf children
                    replaceNode(node: node, child: node.child)
                    deleteCase1(node.child)
                }
                
                return returnVal
            }
        }
        else {
            return nil // node was not found
        }
    }
    
    private func deleteCase1(_ node: Node<T>) {
        if node.parent != nil {
            deleteCase2(node)
        }
    }
    
    private func deleteCase2(_ node: Node<T>) {
        let sibling = node.sibling!
        
        if sibling.color == .red {
            node.parent!.color = .red
            sibling.color = .black
            
            if node == node.parent!.left {
                rotateLeft(node.parent!)
            }
            else {
                rotateRight(node.parent!)
            }
        }
        
        deleteCase3(node)
    }
    
    private func deleteCase3(_ node: Node<T>) {
        let sibling = node.sibling!
        
        if (node.parent!.color == .black) &&
            (sibling.color == .black) &&
            (sibling.left!.color == .black) &&
            (sibling.right!.color == .black)
        {
            sibling.color = .red
            deleteCase1(node.parent!)
        }
        else {
            deleteCase4(node)
        }
    }
    
    private func deleteCase4(_ node: Node<T>) {
        let sibling = node.sibling!
        
        if (node.parent!.color == .red) &&
            (sibling.color == .black) &&
            (sibling.left!.color == .black) &&
            (sibling.right!.color == .black)
        {
            sibling.color = .red
            node.parent!.color = .black
        }
        else {
            deleteCase5(node)
        }
    }
    
    private func deleteCase5(_ node: Node<T>) {
        let sibling = node.sibling!
        
        if sibling.color == .black {
            if (node == node.parent!.left) &&
                (sibling.right!.color == .black) &&
                (sibling.left!.color == .red)
            {
                sibling.color = .red
                sibling.left!.color = .black
                rotateRight(sibling)
            }
            else if (node == node.parent!.right) &&
                (sibling.left!.color == .black) &&
                (sibling.right!.color == .red)
            {
                sibling.color = .red
                sibling.right!.color = .black
                rotateLeft(sibling)
            }
            
        }
        
        deleteCase6(node)
    }
    
    private func deleteCase6(_ node: Node<T>) {
        let sibling = node.sibling!
        
        sibling.color = node.parent!.color
        node.parent!.color = .black
        
        if (node == node.parent!.left) {
            sibling.right!.color = .black
            rotateLeft(node.parent!)
        }
        else {
            sibling.left!.color = .black
            rotateRight(node.parent!)
        }
    }
    
    private func inOrderPredecessor(ofNode node: Node<T>) -> Node<T>? {
        func inOrderPredecessor(_ currentNode: Node<T>) -> Node<T> {
            if currentNode.hasRightChild {
                return inOrderPredecessor(currentNode.right!)
            }
            else {
                return currentNode
            }
        }
        
        if node.hasLeftChild {
            return inOrderPredecessor(node.left!)
        }
        else {
            return nil
        }
    }
    
    private func inOrderSuccessor(ofNode node: Node<T>) -> Node<T>? {
        func inOrderSuccessor(_ currentNode: Node<T>) -> Node<T> {
            if currentNode.hasLeftChild {
                return inOrderSuccessor(currentNode.left!)
            }
            else {
                return currentNode
            }
        }
        
        if node.hasRightChild {
            return inOrderSuccessor(node.right!)
        }
        else {
            return nil
        }
    }
    
    private func swapNodeData(node1: Node<T>, node2: Node<T>) {
        let temp = node1.data
        node1.data = node2.data
        node2.data = temp
    }
    
    private func swapNodeColors(node1: Node<T>, node2: Node<T>) {
        let temp = node1.color
        node1.color = node2.color
        node2.color = temp
    }
    
    private func replaceNode(node: Node<T>, child: Node<T>) {
        child.parent = node.parent
        
        if let parent = node.parent {
            if parent.left == node {
                parent.left = child
            }
            else {
                parent.right = child
            }
        }
        else {
            root = child // we are replacing the root
        }
    }
    
    ////////////////////////////////////////////////////////
    // Functions for tree rotations
    ////////////////////////////////////////////////////////
    
    private func rotateLeft(_ root: Node<T>) {
        let gp = root.parent
        let pivot = root.right!
        let temp = pivot.left!
        
        pivot.left = root
        root.right = temp
        
        pivot.parent = gp
        root.parent = pivot
        temp.parent = root
        
        // Update the root if necessary
        if gp == nil {
            self.root = pivot
        }
            
            // Make sure the grandparent (gp) now references the correct child
        else {
            if gp!.left == root {
                gp!.left = pivot
            }
            else {
                gp!.right = pivot
            }
        }
        
        // Check for circular references
        assert(gp != nil ? (gp!.left != nil ? gp!.left != gp!.left!.left : true) : true)
        assert(gp != nil ? (gp!.right != nil ? gp!.right != gp!.right!.right : true) : true)
        
        assert(root.left != nil ? root.left != root.left!.left : true)
        assert(root.right != nil ? root.right != root.right!.right : true)
        
        assert(pivot.left != nil ? pivot.left != pivot.left!.left : true)
        assert(pivot.right != nil ? pivot.right != pivot.right!.right : true)
        
        assert(temp.left != nil ? temp.left != temp.left!.left : true)
        assert(temp.right != nil ? temp.right != temp.right!.right : true)
    }
    
    private func rotateRight(_ root: Node<T>) {
        let gp = root.parent
        let pivot = root.left!
        let temp = pivot.right!
        
        pivot.right = root
        root.left = temp
        
        pivot.parent = gp
        root.parent = pivot
        temp.parent = root
        
        // Update the root if necessary
        if gp == nil {
            self.root = pivot
        }
            
            // Make sure the grandparent (gp) now references the correct child
        else {
            if gp!.left == root {
                gp!.left = pivot
            }
            else {
                gp!.right = pivot
            }
        }
        
        // Check for circular references
        assert(gp != nil ? (gp!.left != nil ? gp!.left != gp!.left!.left : true) : true)
        assert(gp != nil ? (gp!.right != nil ? gp!.right != gp!.right!.right : true) : true)
        
        assert(root.left != nil ? root.left != root.left!.left : true)
        assert(root.right != nil ? root.right != root.right!.right : true)
        
        assert(pivot.left != nil ? pivot.left != pivot.left!.left : true)
        assert(pivot.right != nil ? pivot.right != pivot.right!.right : true)
        
        assert(temp.left != nil ? temp.left != temp.left!.left : true)
        assert(temp.right != nil ? temp.right != temp.right!.right : true)
    }
    
    func get(_ value: T) -> T? {
        func get(_ node: Node<T>?, _ data: T) -> T? {
            if node == nil || node!.isNullNode {
                return nil
            }
            else if data < node!.data! {
                return get(node!.left, data)
            }
            else if data > node!.data! {
                return get(node!.right, data)
            }
            else {
                return node!.data!
            }
        }
        
        return get(root, value)
    }
    
    func contains(_ value: T) -> Bool {
        return get(value) != nil
    }
    
    ////////////////////////////////////////////////////////
    // Functions for traversals
    ////////////////////////////////////////////////////////
    
    func traverse(traversalType: RedBlackTreeTraversalType, onNodeTouched: (NodeContents<T>) -> ()) {
        switch traversalType {
        case .inOrder:
            inOrderTraversal(root, onNodeTouched: onNodeTouched)
        case .preOrder:
            preOrderTraversal(root, onNodeTouched: onNodeTouched)
        default:
            postOrderTraversal(root, onNodeTouched: onNodeTouched)
        }
    }
    
    private func makeNodeContentsStruct(nodeToMakeItFrom node: Node<T>) -> NodeContents<T> {
        return NodeContents<T>(nodeContents:        node.data!,
                               nodeColor:           node.color,
                               leftChildContents:   node.left?.data,
                               rightChildContents:  node.right?.data,
                               parentContents:      node.parent?.data,
                               description:         node.description)
    }
    
    private func inOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (NodeContents<T>) -> ()) {
        if let node = nodeOp {
            if node.data != nil {
                inOrderTraversal(node.left, onNodeTouched: onNodeTouched)
                onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
                //onNodeTouched(node)
                inOrderTraversal(node.right, onNodeTouched: onNodeTouched)
            }
        }
    }
    
    private func preOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (NodeContents<T>) -> ()) {
        if let node = nodeOp {
            if node.data != nil {
                onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
                //onNodeTouched(node)
                preOrderTraversal(node.left, onNodeTouched: onNodeTouched)
                preOrderTraversal(node.right, onNodeTouched: onNodeTouched)
            }
        }
    }
    
    private func postOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (NodeContents<T>) -> ()) {
        if let node = nodeOp {
            if node.data != nil {
                postOrderTraversal(node.left, onNodeTouched: onNodeTouched)
                postOrderTraversal(node.right, onNodeTouched: onNodeTouched)
                onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
                //onNodeTouched(node)
            }
        }
    }
    
    private func color(of node: Node<T>?) -> RedBlackTreeColor {
        return node == nil ? .black : node!.color
    }
    
    func checkTree() {
        var numNodes = 0
        var numNoParentNodes = 0
        let queue = Queue<Int>()
        
        func checkTree(node: Node<T>?, numberOfBlackNodes: Int) {
            if node == nil {
                return
            }
            else if node!.isNullNode {
                queue.enqueue(numberOfBlackNodes)
                assert(node!.color == .black) // check Property 3
            }
            else {
                numNodes += 1
                
                if node!.parent == nil {
                    numNoParentNodes += 1
                }
                
                let numberOfBlackNodes = node!.color == .black ? numberOfBlackNodes + 1 : numberOfBlackNodes
                
                if node!.color == .red {
                    assert(color(of: node!.left) == .black && color(of: node!.right) == .black) // assert Property 4
                }
                
                checkTree(node: node!.left, numberOfBlackNodes: numberOfBlackNodes)
                checkTree(node: node!.right, numberOfBlackNodes: numberOfBlackNodes)
            }
        }
        
        checkTree(node: root!, numberOfBlackNodes: 0)
        
        assert(root!.color == .black) // checks Property 2
        assert(numNodes == numberOfNodes) // ensures the tree is structured properly
        assert(numNoParentNodes == (numberOfNodes == 0 ? 0 : 1)) // ensures the tree is structured properly
        
        var headVal = queue.peek()
        
        while queue.numberOfNodes > 0 {
            let dequeuedValue = queue.dequeue()!
            assert(headVal == dequeuedValue) // checks Property 5
            headVal = dequeuedValue
        }
    }
}

private class Node<T> : CustomStringConvertible, Equatable where T: Comparable, T: CustomStringConvertible {
    var data: T? = nil
    var left: Node<T>? = nil
    var right: Node<T>? = nil
    var parent: Node<T>? = nil
    
    var grandparent: Node<T>? { return parent?.parent }
    var isNullNode: Bool { return data == nil }
    var hasLeftChild: Bool { return left != nil && left!.isNullNode == false }
    var hasRightChild: Bool { return right != nil && right!.isNullNode == false }
    var color: RedBlackTreeColor {
        set {
            rbtColor = (data == nil ? .black : newValue)
        }
        get {
            if data == nil {
                rbtColor = .black
            }
            
            return rbtColor
        }
    }
    public var description: String {
        let nodeDescription   = "  NODE: \(data == nil ? "nil" : data!.description) (\(color))"
        let parentDescription = "PARENT: " + (parent == nil ? "nil" : (parent!.data == nil ? "null node" : parent!.data!.description))
        let leftDescription   = "  LEFT: " + (  left == nil ? "nil" : (  left!.data == nil ? "null node" :   left!.data!.description))
        let rightDescription  = " RIGHT: " + ( right == nil ? "nil" : ( right!.data == nil ? "null node" :  right!.data!.description))
        return "\(nodeDescription)\n\(parentDescription)\n\(leftDescription)\n\(rightDescription)"
    }
    var sibling: Node<T>? {
        if let parent = self.parent {
            if parent.left == self {
                return parent.right
            }
            else {
                return parent.left
            }
        }
        else {
            return nil
        }
    }
    var child: Node<T> {
        if hasLeftChild {
            return left!
        }
        else if hasRightChild {
            return right!
        }
        else {
            return left! // choose the left child, which is a null node
        }
    }
    var uncle: Node<T>? { return parent?.sibling }
    
    private var rbtColor = RedBlackTreeColor.black // set it to a value; may (and probably will) change in init
    
    init(data: T) {
        unnullify(withThisStoredInTheNode: data, andThisAsItsParent: nil)
    }
    
    init() {
        // Use default values
    }
    
    /**
     Turns a node that is _not_ a null node into a null node
     */
    func nullify() {
        self.data = nil
        self.left = nil
        self.right = nil
    }
    
    /**
     Turns a node that_is_ a null node into a non-null node. 
     _Also note that this changes the color of this node to red!_
     
     - parameters:
        - data: the data to store in this node
        - parent: this node's parent
    */
    func unnullify(withThisStoredInTheNode data: T, andThisAsItsParent parentOp: Node<T>?) {
        self.data = data
        self.color = .red
        self.left = Node<T>()
        self.right = Node<T>()
        self.parent = parentOp
        
        // If we have have to add a node and it is NOT the root (i.e., if there is no node, but there is a parent)
        if let parent = parentOp {
            
            if data < parent.data! {
                parent.left = self
            }
            else {
                parent.right = self
            }
        }
    }
    
    public static func ==(lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.data == rhs.data
    }
}

public struct NodeContents<T: Comparable> : CustomStringConvertible, Equatable {
    var nodeContents: T
    var nodeColor: RedBlackTreeColor
    var leftChildContents: T?
    var rightChildContents: T?
    var parentContents: T?
    public var description: String

    public static func ==(lhs: NodeContents<T>, rhs: NodeContents<T>) -> Bool {
        return lhs.nodeContents == rhs.nodeContents
    }
}

public enum RedBlackTreeColor : CustomStringConvertible {
    case red, black
    
    public var description: String {
        switch self {
        case .red:
            return "Red"
        default:
            return "Black"
        }
    }
}

public enum RedBlackTreeTraversalType {
    /** In-Order traversal (left child, current node, right child) */
    case inOrder
    
    /** Pre-Order traversal (current node, left child, right child) */
    case preOrder
    
    /** Post-Order traversal (left child, right child, current node) */
    case postOrder
}

public enum RedBlackTreeTextualRepresentationType {
    case descriptive
    case succinct
}
