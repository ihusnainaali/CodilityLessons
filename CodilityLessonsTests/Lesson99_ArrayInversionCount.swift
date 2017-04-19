//
//  Lesson99_ArrayInversionCount.swift
//  CodilityLessons
//
//  Created by Oleksandr Malovichko on 4/18/17.
//
//

import XCTest
// TODO: finish it with Merge sort

class Lesson99_ArrayInversionCount: XCTestCase {
    
    func test() {
        var arr = [Int]()
        
        arr = [10, 2, 1, 4]
        XCTAssertEqual(solution(&arr), 4)
        
        arr = [10, 2, 1, 4, 1, -1, 19]
        XCTAssertEqual(solution(&arr), 12)
        
        arr = [10, 2, 1, 4, 1, -1, 19, 1]
        XCTAssertEqual(solution(&arr), 16)
        
        arr = [1, 0, 3, 2, 4, 3]
        XCTAssertEqual(solution(&arr), 3)
        
        arr = [1, 0]
        XCTAssertEqual(solution(&arr), 1)
        
        arr = [-1, 6, 3, 4, 7, 4]
        XCTAssertEqual(solution(&arr), 4)
    }
    
    func testMeasure1() {
        measure {
            var arr = [Int]()
            for i in 0..<1_000 {
                arr.append(10_000 - i)
            }
            XCTAssertEqual(self.solution(&arr), 499500)
        }
    }
    
    func testMeasure2() {
        measure {
            var arr = [Int]()
            for i in 0..<1_000 {
                arr.append(i)
            }
            XCTAssertEqual(self.solution(&arr), 0)
        }

    }
    
    
    
    public func solution(_ A : inout [Int]) -> Int {
        let count = A.count
        
        if count <= 1 {
            return 0
        }
        
        var result = 0
        
        let first = A.first!
        A.removeFirst()
        
        var tree = Tree(first)
        
        var minValue = first
        var maxValue = first
        
        var rightSubTree: Tree? = nil
        var leftSubTree: Tree? = nil
        
        for i in 1..<count {
            let a = A[i]
            
//            if a > maxValue {
//                if let r = rightSubTree {
//                    _ = r.insertValue(value: a)
//                } else {
//                    rightSubTree = Tree(a)
//                }
//                maxValue = a
//                continue
//            } else if rightSubTree != nil {
//                tree.insertTreeToRight(tree: rightSubTree!)
//                rightSubTree = nil
//            }
//            
//            minValue = min(minValue, a)
//            maxValue = max(maxValue, a)
            
            result += tree.insertValue(value: a)
            tree = rotateTree(tree: tree)
            if result > 1_000_000_000 {
                return -1
            }
        }
        
        return result
    }
    
    func rotateTree(tree: Tree) -> Tree {
        let l = tree.leftCount
        let r = tree.rightCount
        if abs(l - r) < 2 {
            return tree
        }
        if l > r {
            // Right rotation
            let newTop = tree.left!
            
            let branch = newTop.right
            let branchCount = newTop.rightCount
            
            tree.left = branch
            tree.leftCount = branchCount
            
            newTop.right = tree
            newTop.rightCount = tree.count + tree.leftCount + tree.rightCount
            
            return newTop
        } else {
            // Left rotation
            let newTop = tree.right!
            
            let branch = newTop.left
            let branchCount = newTop.leftCount
            
            tree.right = branch
            tree.rightCount = branchCount
            
            newTop.left = tree
            newTop.leftCount = tree.count + tree.leftCount + tree.rightCount
            
            return newTop
        }
    }
    
    class Tree {
        var value: Int
        var count: Int
        
        var left : Tree?
        var leftCount = 0
        
        var right : Tree?
        var rightCount = 0
        
//        func insertTreeToRight(tree: Tree) {
//            rightCount += tree.rightCount
//            if let r = right {
//                r.insertTreeToRight(tree: tree)
//            } else {
//                right = tree
//            }
//        }
        
        func insertValue(value newValue: Int, n: Int = 0) -> Int {
            if value > newValue {
                leftCount += 1
                if let l = left {
                    return l.insertValue(value: newValue, n: n + count + rightCount)
                }
                left = Tree(newValue)
                return n + count + rightCount
            } else if value < newValue {
                rightCount += 1
                if let r = right {
                    return r.insertValue(value: newValue, n: n)
                }
                right = Tree(newValue)
                return n
            } else {
                count += 1
                return n + rightCount
            }
        }
        
        init(_ value: Int) {
            self.value = value
            count = 1
        }
    }
}
