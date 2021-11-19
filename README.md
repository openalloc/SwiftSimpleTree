# SwiftSimpleTree

A nested data structure that’s flexible and easy to use.

Available as an open source Swift library to be incorporated in other apps.

_SwiftSimpleTree_ is part of the [OpenAlloc](https://github.com/openalloc) family of open source Swift software tools.

## SimpleTree

```swift
let foo = SimpleTree<String>(value: "foo")
let bar = foo.addChild(for: "bar")
let baz = bar.addChild(for: "baz")

print(foo.getFirst(for: "baz")?.value)

=> "baz"

print(baz.getParentValues())

=> ["bar", "foo"]

print(foo.getChildValues())

=> ["bar", "baz"]
```

## Types

Types scoped within `SimpleTree`:

- `typealias Node = SimpleTree<T>` - a tree node, where `T` is your hashable type.

- `typealias ValueSet = Set<T>` - a set of values, where `T` is your hashable type.

## Instance Methods

#### Tree Maintenance

- `init(value: T)`: Initialize a new tree (containing the specified value at the root)

- `func addChild(for: T) -> Node`: Append a new node (containing the specified value) to our list of children

#### Node Retrieval

- `func getChildren(excludeValues: ValueSet) -> [Node]`: Fetch the child nodes of the node. Optional list of values for children to be excluded, along with their progeny. Traversal is breadth-first.

- `func getChildren(maxDepth: Int, excludeValues: ValueSet) -> [Node]`: Fetch the child nodes of the node. Optional list of values for children to be excluded, along with their progeny. Traversal is depth-first.

- `func getParent(excludeValues: ValueSet) -> Node?`: Return the immediate parent node, if any. Optional list of parent values to be excluded. A match will cause this function to return nil.

- `func getParents(maxDepth: Int, excludeValues: ValueSet) -> [Node]`: Return the parent nodes, starting with immediate parent. Optional list of parent values to be excluded. A match will exclude further ancestors. Optional limit on depth.

- `func getSelfAndChildren(excludeValues: ValueSet) -> [Node]`: Fetch the node and its child nodes. Optional list of values for nodes to be excluded, along with their progeny. Traversal is breadth-first.

#### Node Search

- `func getFirst(for: T) -> Node?`: Traverse from the current node to find the first node with the specified value. Traversal is breadth-first.

- `func getFirstChild(for: T) -> Node?`: Traverse the children from the current node to find the first child (grandchild, etc.) with the specified value. Traversal is breadth-first.

#### Iterators

- `func makeChildIterator(excludeValues: ValueSet) -> AnyIterator<Node>`: Create a iterator to traverse through the children (grandchildren, etc.) of the current node. Traversal is breadth-first. With short circuit of child branches on exclude filter.

- `func makeParentIterator() -> AnyIterator<Node>`: Create a iterator to traverse up the tree through the parents of the current node, starting with the most recent parent, if any.

#### Value retrieval

- `func getChildValues(excludeValues: ValueSet) -> [T]`: Fetch the values of the child nodes. Optional list of values for children to be excluded, along with their progeny. Traversal is breadth-first.

- `func getChildValues(maxDepth: Int, excludeValues: ValueSet) -> [T]`: Fetch the values of the child nodes. Optional list of values for children to be excluded, along with their progeny. Traversal is depth-first.

- `func getParentValue(excludeValues: ValueSet) -> T?`: Return the value of the immediate parent node, if any. Optional list of parent values to be excluded. A match will cause this function to return nil.

- `func getParentValues(maxDepth: Int, excludeValues: ValueSet) -> [T]`: Return the values of the parent nodes, starting with immediate parent. Optional list of parent values to be excluded. A match will exclude further ancestors. Optional limit on depth.

- `func getSelfAndChildValues(excludeValues: ValueSet) -> [T]`: Fetch values for the node and its child nodes. Includes value of current node. Optional list of values for nodes to be excluded, along with their progeny. Traversal is breadth-first.

## See Also

Swift open-source libraries (by the same author):

* [AllocData](https://github.com/openalloc/AllocData) - standardized data formats for investing-focused apps and tools
* [FINporter](https://github.com/openalloc/FINporter) - library and command-line tool to transform various specialized finance-related formats to the standardized schema of AllocData
* [SwiftCompactor](https://github.com/openalloc/SwiftCompactor) - formatters for the concise display of Numbers, Currency, and Time Intervals
* [SwiftModifiedDietz](https://github.com/openalloc/SwiftModifiedDietz) - A tool for calculating portfolio performance using the Modified Dietz method
* [SwiftNiceScale](https://github.com/openalloc/SwiftNiceScale) - generate 'nice' numbers for label ticks over a range, such as for y-axis on a chart
* [SwiftRegressor](https://github.com/openalloc/SwiftRegressor) - a linear regression tool that’s flexible and easy to use

And commercial apps using this library (by the same author):

* [FlowAllocator](https://flowallocator.app/FlowAllocator/index.html) - portfolio rebalancing tool for macOS
* [FlowWorth](https://flowallocator.app/FlowWorth/index.html) - a new portfolio performance and valuation tracking tool for macOS

## License

Copyright 2021 FlowAllocator LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Contributing

Contributions are welcome. You are encouraged to submit pull requests to fix bugs, improve documentation, or offer new features. 

The pull request need not be a production-ready feature or fix. It can be a draft of proposed changes, or simply a test to show that expected behavior is buggy. Discussion on the pull request can proceed from there.

Contributions should ultimately have adequate test coverage. See tests for current entities to see what coverage is expected.
