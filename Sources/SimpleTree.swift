//
//  SimpleTree.swift
//
// Copyright 2021, 2022 OpenAlloc LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

public class SimpleTree<T> where T: Equatable & Hashable {
    public typealias Node = SimpleTree<T>
    public typealias ValueSet = Set<T>

    public var value: T
    private(set) var children: [Node] = []
    private(set) var parent: Node?

    public init(value: T) {
        self.value = value
    }
}

// MARK: - Tree Maintenance

public extension SimpleTree {
    /// Append a new node (containing the specified value) to our list of children
    func addChild(value: T) -> Node {
        let nuChild = Node(value: value)
        children.append(nuChild)
        nuChild.parent = self
        return nuChild
    }

    // TODO: need removeChild() which will also deal with grandchildren, etc.
}

// MARK: - Node Retrieval

public extension SimpleTree {
    enum Traversal {
        case depthFirst
        case breadthFirst
    }

    /// Return the parent nodes, starting with immediate parent.
    /// Optional list of parent values to be excluded. A match will exclude further ancestors.
    /// Optional limit on depth.
    func getParents(maxDepth: UInt = UInt.max, excludeValues: ValueSet = ValueSet()) -> [Node] {
        guard maxDepth > 0 else { return [] }
        let iter = makeParentIterator()
        var depth = maxDepth
        var parents = [Node]()
        while let parentNode = iter.next() {
            if excludeValues.contains(parentNode.value) { break }
            parents.append(parentNode)
            if depth == 1 { break }
            depth -= 1
        }
        return parents
    }

    /// Return the immediate parent node, if any.
    /// Optional list of parent values to be excluded. A match will cause this function to return nil.
    func getParent(excludeValues: ValueSet = ValueSet()) -> Node? {
        getParents(maxDepth: 1, excludeValues: excludeValues).first
    }

    /// Fetch the child nodes of the node.
    /// Optional list of values for children to be excluded, along with their progeny.
    /// Traversal is breadth-first by default.
    /// NOTE: breadth-first with maxDepth not yet supported.
    func getChildren(traversal: Traversal = .breadthFirst, maxDepth: UInt = UInt.max, excludeValues: ValueSet = ValueSet()) -> [Node] {
        var nodes = [Node]()
        switch traversal {
        case .depthFirst:
            if maxDepth > 0 {
                for child in children {
                    if excludeValues.contains(child.value) { continue }
                    nodes.append(child)
                    if maxDepth > 1 {
                        let _children = child.getChildren(traversal: .depthFirst, maxDepth: maxDepth - 1, excludeValues: excludeValues)
                        nodes.append(contentsOf: _children)
                    }
                }
            }
        case .breadthFirst:
            guard maxDepth == UInt.max else { fatalError("breadth-first with maxDepth not yet supported") }
            let iter = makeChildIterator(excludeValues: excludeValues)
            while let node = iter.next() {
                nodes.append(node)
            }
        }
        return nodes
    }

    /// Fetch the node and its child nodes.
    /// Optional list of values for nodes to be excluded, along with their progeny.
    /// Traversal is breadth-first by default.
    /// Self is at the first level of depth, so maxDepth: 0 returns [].
    /// NOTE: breadth-first with maxDepth not yet supported.
    func getSelfAndChildren(traversal: Traversal = .breadthFirst, maxDepth: UInt = UInt.max, excludeValues: ValueSet = ValueSet()) -> [Node] {
        guard !excludeValues.contains(value), maxDepth > 0 else { return [] }
        var nodes: [Node] = [self]
        let netMaxDepth = maxDepth - (traversal == .depthFirst ? 1 : 0)
        nodes.append(contentsOf: getChildren(traversal: traversal, maxDepth: netMaxDepth, excludeValues: excludeValues))
        return nodes
    }
}

// MARK: - Iterators

public extension SimpleTree {
    /// Create a iterator to traverse up the tree through the parents of the current node, starting with the most recent parent, if any.
    func makeParentIterator() -> AnyIterator<Node> {
        var node: Node? = parent
        return AnyIterator { () -> Node? in
            guard let _node = node else { return nil }
            let nextNode = _node
            node = _node.parent // okay if nil
            return nextNode
        }
    }

    /// Create a iterator to traverse through the children (grandchildren, etc.) of the current node.
    /// Traversal is breadth-first.
    /// With short circuit of child branches on exclude filter.
    func makeChildIterator(excludeValues: ValueSet = ValueSet()) -> AnyIterator<Node> {
        var stack = children
        var node: Node? = stack.isEmpty ? nil : stack.removeFirst()
        return AnyIterator { () -> Node? in
            guard node != nil else { return nil }

            var nextNode: Node? = nil

            // burn through stack to find next available non-excluded value
            while node != nil {
                nextNode = node
                if let cv = nextNode?.value,
                   excludeValues.contains(cv)
                {
                    node = stack.isEmpty ? nil : stack.removeFirst()
                    nextNode = nil
                    continue
                }
                break
            }

            if let _node = node {
                stack.append(contentsOf: _node.children)
            }

            if stack.isEmpty {
                node = nil
            } else {
                node = stack.removeFirst()
            }

            return nextNode
        }
    }
}

// MARK: - Node Search

public extension SimpleTree {
    /// Traverse the children from the current node to find the first child (grandchild, etc.) with the specified value.
    /// Traversal is breadth-first.
    func getFirstChild(for value: T) -> Node? {
        let iter = makeChildIterator()
        while let node = iter.next() {
            if node.value == value {
                return node
            }
        }
        return nil
    }

    /// Traverse from the current node to find the first node with the specified value.
    /// Includes current node.
    /// Traversal is breadth-first.
    func getFirst(for value: T) -> Node? {
        guard self.value != value else { return self }
        return getFirstChild(for: value)
    }
}

// MARK: - Value retrieval

public extension SimpleTree {
    /// Fetch the values of the child nodes.
    /// Optional list of values for children to be excluded, along with their progeny.
    /// Traversal is breadth-first by default.
    /// NOTE: breadth-first with maxDepth not yet supported.
    func getChildValues(traversal: Traversal = .breadthFirst, maxDepth: UInt = UInt.max, excludeValues: ValueSet = ValueSet()) -> [T] {
        getChildren(traversal: traversal, maxDepth: maxDepth, excludeValues: excludeValues).map(\.value)
    }

    /// Fetch values for the node and its child nodes.
    /// Includes value of current node.
    /// Optional list of values for nodes to be excluded, along with their progeny.
    /// Self is at the first level of depth, so maxDepth: 0 returns [].
    /// Traversal is breadth-first, by default.
    /// NOTE: breadth-first with maxDepth not yet supported.
    func getSelfAndChildValues(traversal: Traversal = .breadthFirst, maxDepth: UInt = UInt.max, excludeValues: ValueSet = ValueSet()) -> [T] {
        getSelfAndChildren(traversal: traversal, maxDepth: maxDepth, excludeValues: excludeValues).map(\.value)
    }

    /// Return the values of the parent nodes, starting with immediate parent.
    /// Optional list of parent values to be excluded. A match will exclude further ancestors.
    /// Optional limit on depth.
    func getParentValues(maxDepth: UInt = UInt.max, excludeValues: ValueSet = ValueSet()) -> [T] {
        getParents(maxDepth: maxDepth, excludeValues: excludeValues).map(\.value)
    }

    /// Return the value of the immediate parent node, if any.
    /// Optional list of parent values to be excluded. A match will cause this function to return nil.
    func getParentValue(excludeValues: ValueSet = ValueSet()) -> T? {
        getParent(excludeValues: excludeValues)?.value
    }
}
