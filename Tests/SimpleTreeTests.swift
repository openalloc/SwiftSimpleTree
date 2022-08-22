//
//  SimpleTreeTests.swift
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

@testable import SimpleTree
import XCTest

/// Shallow equator, exclusively for purposes of testing
extension SimpleTree: Equatable {
    public static func == (lhs: SimpleTree.Node, rhs: SimpleTree.Node) -> Bool {
        lhs.value == rhs.value
    }
}

final class SimpleTreeTests: XCTestCase {
   
    typealias SST = SimpleTree<String>
    
    public func testExample() {
        let foo = SimpleTree(value: "foo")
        let bar = foo.addChild(value: "bar")
        let baz = bar.addChild(value: "baz")

        XCTAssertEqual("baz", foo.getFirst(for: "baz")?.value)
        XCTAssertEqual(["bar", "foo"], baz.getParentValues())
        XCTAssertEqual(["bar", "baz"], foo.getChildValues())
        XCTAssertEqual(["foo", "bar", "baz"], foo.getSelfAndChildValues())
    }
    
    public func testGetParentValues() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        let baz2 = foo.addChild(value: "bar2")
        let baz = bar.addChild(value: "baz")
        let blah = bar.addChild(value: "blah")

        XCTAssertEqual(blah.getParentValues(), ["bar", "foo"])
        XCTAssertEqual(blah.getParentValues(maxDepth: 0), [])
        XCTAssertEqual(blah.getParentValues(maxDepth: 1), ["bar"])
        XCTAssertEqual(blah.getParentValues(maxDepth: 2), ["bar", "foo"])
        XCTAssertEqual(blah.getParentValues(maxDepth: 10000), ["bar", "foo"])

        XCTAssertEqual(blah.getParentValues(excludeValues: ["foo"]), ["bar"])
        XCTAssertEqual(blah.getParentValues(excludeValues: ["bar"]), [])
        XCTAssertEqual(blah.getParentValues(excludeValues: ["bar2"]), ["bar", "foo"])
        XCTAssertEqual(blah.getParentValues(excludeValues: ["baz"]), ["bar", "foo"])
        XCTAssertEqual(blah.getParentValues(excludeValues: ["blah"]), ["bar", "foo"])

        XCTAssertEqual(blah.getParentValue(), "bar")
        XCTAssertEqual(foo.getParentValue(), nil)
        XCTAssertEqual(bar.getParentValue(), "foo")
        XCTAssertEqual(baz2.getParentValue(), "foo")
        XCTAssertEqual(baz.getParentValue(), "bar")
    }
    
    public func testMakeParentIterator() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        let baz2 = foo.addChild(value: "baz2")
        let baz = bar.addChild(value: "baz")
        let blah = bar.addChild(value: "blah")

        let blahIt = blah.makeParentIterator()
        XCTAssertEqual("bar", blahIt.next()?.value)
        XCTAssertEqual("foo", blahIt.next()?.value)
        XCTAssertNil(blahIt.next()?.value)
        
        let baz2It = baz2.makeParentIterator()
        XCTAssertEqual("foo", baz2It.next()?.value)
        XCTAssertNil(baz2It.next()?.value)
        
        let bazIt = baz.makeParentIterator()
        XCTAssertEqual("bar", bazIt.next()?.value)
        XCTAssertEqual("foo", bazIt.next()?.value)
        XCTAssertNil(bazIt.next()?.value)

        let barIt = bar.makeParentIterator()
        XCTAssertEqual("foo", barIt.next()?.value)
        XCTAssertNil(barIt.next()?.value)

        let fooIt = foo.makeParentIterator()
        XCTAssertNil(fooIt.next()?.value)
    }

    public func testMakeChildIterator() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        let baz2 = foo.addChild(value: "baz2")
        let bleep = baz2.addChild(value: "bleep")
        let blort = bleep.addChild(value: "blort")
        let baz = bar.addChild(value: "baz")
        let blah = bar.addChild(value: "blah")

        let blahIt = blah.makeChildIterator()
        XCTAssertNil(blahIt.next()?.value)
        
        let baz2It = baz2.makeChildIterator()
        XCTAssertEqual("bleep", baz2It.next()?.value)
        XCTAssertEqual("blort", baz2It.next()?.value)
        XCTAssertNil(baz2It.next()?.value)
  
        let bleepIt = bleep.makeChildIterator()
        XCTAssertEqual("blort", bleepIt.next()?.value)
        XCTAssertNil(bleepIt.next()?.value)

        let blortIt = blort.makeChildIterator()
        XCTAssertNil(blortIt.next()?.value)
        
        let bazIt = baz.makeChildIterator()
        XCTAssertNil(bazIt.next()?.value)

        let barIt = bar.makeChildIterator()
        XCTAssertEqual("baz", barIt.next()?.value)
        XCTAssertEqual("blah", barIt.next()?.value)
        XCTAssertNil(barIt.next()?.value)

        let fooIt = foo.makeChildIterator()
        XCTAssertEqual("bar", fooIt.next()?.value)
        XCTAssertEqual("baz2", fooIt.next()?.value)
        XCTAssertEqual("baz", fooIt.next()?.value)
        XCTAssertEqual("blah", fooIt.next()?.value)
        XCTAssertEqual("bleep", fooIt.next()?.value)
        XCTAssertEqual("blort", fooIt.next()?.value)
        XCTAssertNil(fooIt.next()?.value)
    }

    public func testGetFirst() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        let baz = bar.addChild(value: "baz")

        XCTAssertNil(foo.getFirstChild(for: "foo"))
        XCTAssertEqual(foo.getFirstChild(for: "bar"), bar)
        XCTAssertEqual(foo.getFirstChild(for: "baz"), baz)
        XCTAssertNil(foo.getFirstChild(for: "blah"))

        XCTAssertEqual(foo.getFirst(for: "foo"), foo)
        XCTAssertEqual(foo.getFirst(for: "bar"), bar)
        XCTAssertEqual(foo.getFirst(for: "baz"), baz)
        XCTAssertNil(foo.getFirst(for: "blah"))
    }

    public func testGetChildValuesNone() throws {
        let foo = SST(value: "foo")
        XCTAssertEqual(foo.getChildValues(), [])
    }
    
    public func testGetChildValuesOneChild() throws {
        let foo = SST(value: "foo")
        _ = foo.addChild(value: "bar")
        XCTAssertEqual(foo.getChildValues(), ["bar"])
    }
    
    public func testGetChildValuesOneGrandChild() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        _ = bar.addChild(value: "baz")
        XCTAssertEqual(foo.getChildValues(), ["bar", "baz"])
    }

    public func testGetChildValues() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        let bar2 = foo.addChild(value: "bar2")
        _ = bar2.addChild(value: "bar3")
        let baz = bar.addChild(value: "baz")
        let blah = bar.addChild(value: "blah")
        _ = blah.addChild(value: "bleh")

        for traversal in [SST.Traversal.depthFirst, SST.Traversal.breadthFirst] {
            XCTAssertEqual(foo.getChildValues(traversal: traversal).sorted(), ["bar", "bar2", "bar3", "baz", "blah", "bleh"].sorted())
            XCTAssertEqual(bar.getChildValues(traversal: traversal).sorted(), ["baz", "blah", "bleh"].sorted())
            XCTAssertEqual(bar2.getChildValues(traversal: traversal), ["bar3"])
            XCTAssertEqual(baz.getChildValues(traversal: traversal), [])
            XCTAssertEqual(blah.getChildValues(traversal: traversal), ["bleh"])
        }
        
        XCTAssertEqual(foo.getChildValues(traversal: .depthFirst, maxDepth: 1000).sorted(), ["bar", "bar2", "bar3", "baz", "blah", "bleh"].sorted())
        XCTAssertEqual(foo.getChildValues(traversal: .depthFirst, maxDepth: 3).sorted(), ["bar", "bar2", "bar3", "baz", "blah", "bleh"].sorted())
        XCTAssertEqual(foo.getChildValues(traversal: .depthFirst, maxDepth: 2).sorted(), ["bar", "bar2", "bar3", "baz", "blah"].sorted())
        XCTAssertEqual(foo.getChildValues(traversal: .depthFirst, maxDepth: 1).sorted(), ["bar", "bar2"].sorted())
        XCTAssertEqual(foo.getChildValues(traversal: .depthFirst, maxDepth: 0).sorted(), [].sorted())
    }
    
    public func testGetSelfAndChildValues() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        let bar2 = foo.addChild(value: "bar2")
        _ = bar2.addChild(value: "bar3")
        let baz = bar.addChild(value: "baz")
        let blah = bar.addChild(value: "blah")
        _ = blah.addChild(value: "bleh")

        for traversal in [SST.Traversal.depthFirst, SST.Traversal.breadthFirst] {
            XCTAssertEqual(foo.getSelfAndChildValues(traversal: traversal).sorted(), ["bar", "bar2", "bar3", "baz", "blah", "bleh", "foo"].sorted())
            XCTAssertEqual(bar.getSelfAndChildValues(traversal: traversal).sorted(), ["bar", "baz", "blah", "bleh"].sorted())
            XCTAssertEqual(bar2.getSelfAndChildValues(traversal: traversal), ["bar2", "bar3"])
            XCTAssertEqual(baz.getSelfAndChildValues(traversal: traversal), ["baz"])
            XCTAssertEqual(blah.getSelfAndChildValues(traversal: traversal), ["blah", "bleh"])
        }

        XCTAssertEqual(foo.getSelfAndChildValues(traversal: .depthFirst, maxDepth: 1000).sorted(), ["bar", "bar2", "bar3", "baz", "blah", "bleh", "foo"].sorted())
        XCTAssertEqual(foo.getSelfAndChildValues(traversal: .depthFirst, maxDepth: 3).sorted(), ["bar", "bar2", "bar3", "baz", "blah", "foo"].sorted())
        XCTAssertEqual(foo.getSelfAndChildValues(traversal: .depthFirst, maxDepth: 2).sorted(), ["bar", "bar2", "foo"].sorted())
        XCTAssertEqual(foo.getSelfAndChildValues(traversal: .depthFirst, maxDepth: 1).sorted(), ["foo"].sorted())
        XCTAssertEqual(foo.getSelfAndChildValues(traversal: .depthFirst, maxDepth: 0).sorted(), [].sorted())
    }
    
    public func testGetAllChildValues() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        let bar2 = foo.addChild(value: "bar2")
        _ = bar2.addChild(value: "bar3")
        let baz = bar.addChild(value: "baz")
        let blah = bar.addChild(value: "blah")
        _ = blah.addChild(value: "bleh")

        XCTAssertEqual(foo.getChildValues().sorted(), ["bar", "bar2", "bar3", "baz", "blah", "bleh"].sorted())
        XCTAssertEqual(bar.getChildValues().sorted(), ["baz", "blah", "bleh"].sorted())
        XCTAssertEqual(bar2.getChildValues(), ["bar3"])
        XCTAssertEqual(baz.getChildValues(), [])
        XCTAssertEqual(blah.getChildValues(), ["bleh"])
    }

    public func testGetChildValuesExclude() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        let bar2 = foo.addChild(value: "bar2")
        _ = bar2.addChild(value: "bar3")
        _ = bar.addChild(value: "baz")
        _ = bar.addChild(value: "blah")

        XCTAssertEqual(foo.getChildValues(excludeValues: ["bar"]).sorted(), ["bar2", "bar3"].sorted())
        XCTAssertEqual(foo.getChildValues(excludeValues: ["bar2"]).sorted(), ["bar", "baz", "blah"].sorted())
        XCTAssertEqual(bar.getChildValues(excludeValues: ["foo"]).sorted(), ["baz", "blah"].sorted())
        XCTAssertEqual(bar.getChildValues(excludeValues: ["blah"]).sorted(), ["baz"].sorted())
    }
    
    public func testGetChildValues2Exclude() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        let bar2 = foo.addChild(value: "bar2")
        _ = bar2.addChild(value: "bar3")
        _ = bar.addChild(value: "baz")
        _ = bar.addChild(value: "blah")

        //XCTAssertEqual(foo.getChildValues2(excludeValues: ["bar"]), [])
        XCTAssertEqual(foo.getChildValues(excludeValues: ["bar2"]), ["bar", "baz", "blah"])
        XCTAssertEqual(foo.getChildValues(excludeValues: ["blah"]), ["bar", "bar2", "baz", "bar3"])
        XCTAssertEqual(bar.getChildValues(excludeValues: ["foo"]), ["baz", "blah"])
        XCTAssertEqual(bar.getChildValues(excludeValues: ["blah"]), ["baz"])
    }

    public func testGetAllValues() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        let baz = bar.addChild(value: "baz")

        XCTAssertTrue(foo.getSelfAndChildValues().contains("foo"))
        XCTAssertTrue(foo.getSelfAndChildValues().contains("bar"))
        XCTAssertTrue(foo.getSelfAndChildValues().contains("baz"))
        XCTAssertFalse(foo.getSelfAndChildValues().contains("blah"))

        XCTAssertFalse(bar.getSelfAndChildValues().contains("foo"))
        XCTAssertTrue(bar.getSelfAndChildValues().contains("bar"))
        XCTAssertTrue(bar.getSelfAndChildValues().contains("baz"))
        XCTAssertFalse(bar.getSelfAndChildValues().contains("blah"))

        XCTAssertFalse(baz.getSelfAndChildValues().contains("foo"))
        XCTAssertFalse(baz.getSelfAndChildValues().contains("bar"))
        XCTAssertTrue(baz.getSelfAndChildValues().contains("baz"))
        XCTAssertFalse(baz.getSelfAndChildValues().contains("blah"))
    }
    
    public func testGetAllValuesExcludeRoot() throws {
        let foo = SST(value: "foo")
        _ = foo.addChild(value: "bar")

        let actual = foo.getSelfAndChildValues(excludeValues: Set(["foo"]))
        XCTAssertFalse(actual.contains("foo"))
        XCTAssertFalse(actual.contains("bar"))
    }
    
    public func testGetAllValuesExcludeChild() throws {
        let foo = SST(value: "foo")
        let bar = foo.addChild(value: "bar")
        _ = bar.addChild(value: "baz")

        let actual = foo.getSelfAndChildValues(excludeValues: Set(["bar"]))
        XCTAssertTrue(actual.contains("foo"))
        XCTAssertFalse(actual.contains("bar"))
    }
    
    public func testGetAllValuesExcludeSibling() throws {
        let foo = SST(value: "foo")
        
        let blah = foo.addChild(value: "blah")
        _ = blah.addChild(value: "bleh")
        
        let bar = foo.addChild(value: "bar")
        _ = bar.addChild(value: "baz")

        let actual = foo.getSelfAndChildValues(excludeValues: Set(["blah"]))
        XCTAssertTrue(actual.contains("foo"))
        XCTAssertFalse(actual.contains("blah"))
        XCTAssertFalse(actual.contains("bleh"))
        XCTAssertTrue(actual.contains("bar"))
        XCTAssertTrue(actual.contains("baz"))
    }
}
