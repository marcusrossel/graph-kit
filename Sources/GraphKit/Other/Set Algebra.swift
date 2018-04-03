//
//  Set Algebra.swift
//  GraphKit
//
//  Created by Marcus Rossel on 15.03.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

/* Important:
 
 `Keys`/`Values` `.contains` is O(1)
 
 */

// MARK: - Table

extension Graph.Table {
   
   //#warning("Determine complexity.")
   /// Merges another table into this one, by merging their vertex and edge
   /// reference tables and remapping indices if needed.
   internal mutating func formUnion(with other: Graph.Table) {
      // A map between colliding edge indices.
      var indexCollisionMap: [Index: Index] = [:]
      
      // Merges the edge reference tables, and creates the index collision
      // map in the process.
      for (edge, foreignIndex) in other.edgeIndexMap {
         // If both tables contain the same edge, an index collision is
         // recorded. Otherwise the new edge is simply added to the native
         // reference table using the foreign index.
         if let nativeIndex = edgeIndexMap[edge] {
            indexCollisionMap[foreignIndex] = nativeIndex
         } else {
            edgeIndexMap[foreignIndex] = edge
         }
      }
      
      // Merges the vertex tables, while also converting colliding foreign
      // indices to native ones.
      for (vertex, foreignIndices) in other.vertexTable {
         // Converts the colliding foreign indices to native ones.
         let nativeIndices = foreignIndices.map { foreignIndex in
            return indexCollisionMap[foreignIndex] ?? foreignIndex
         }
         
         // Merges the native indices of colliding vertices with the new
         // ones, and creates new entries for new vertices.
         vertexTable[vertex, default: []].formUnion(nativeIndices)
      }
   }
   
   //#warning("Determine complexity.")
   /// Removes the vertices and edges from this table that aren't also in the
   /// given table.
   internal mutating func formIntersection(with other: Graph.Table) {
      // A container for the vertices removed from this table.
      var removedVertices: Set<Graph.Vertex> = []
      
      // Removes all vertices from this table, that are not contained in the
      // other table.
      for vertex in vertexTable.keys {
         if !other.vertexTable.keys.contains(vertex) {
            vertexTable[vertex] = nil
            removedVertices.insert(vertex)
         }
      }
      
      // Removes all edges from this table, that are not contained in the other
      // table.
      for (edge, index) in edgeIndexMap {
         // Gets the edge's vertices.
         let vertices = edge.vertices
         
         // Makes sure either one of the edge's vertices has been removed, or it
         // is not part of the other table.
         guard
            removedVertices.contains(vertices.0) ||
            removedVertices.contains(vertices.1) ||
            !other.edgeIndexMap.keys.contains(edge)
         else { continue }
         
         // Removes the edge from the reference table.
         edgeIndexMap[edge] = nil
         
         // Removes the edge's index from both of its vertices' table entries.
         vertexTable[vertices.0]!.remove(index)
         vertexTable[vertices.1]!.remove(index)
      }
   }
   
   //#warning("Determine complexity.")
   /// Removes the vertices and edges of the given table from this table.
   internal mutating func subtract(_ other: Graph.Table) {
      // A container for the vertices removed from this table.
      var removedVertices: Set<Graph.Vertex> = []
      
      // Removes all vertices from this table that are also contained in the
      // other table. Those vertices are also saved in the container above.
      for vertex in vertexTable.keys {
         if other.vertexTable.keys.contains(vertex) {
            vertexTable[vertex] = nil
            removedVertices.insert(vertex)
         }
      }
      
      // Removes all edges from this table, that contain a removed vertex.
      for (edge, index) in edgeIndexMap {
         // Gets the edge's vertices.
         let vertices = edge.vertices
         
         // Removes the edge from the reference table if either one of its
         // vertices has been removed.
         if removedVertices.contains(vertices.0) || removedVertices.contains(vertices.1) {
            edgeIndexMap[edge] = nil
         }
         
         // Removes the edge's index from both of its vertices' table entries.
         vertexTable[vertices.0]!.remove(index)
         vertexTable[vertices.1]!.remove(index)
      }
   }
   
   //#warning("Determine complexity.")
   /// Replaces this table with the vertices and edges contained in this graph
   /// or the given table, but not both. Edges that incident to a vertex
   /// contained in both tables are therefore removed.
   internal mutating func formSymmetricDifference(with other: Graph.Table) {
      // Creates a mutable shadow of `other`.
      var other = other
      
      // Removes vertices contained in both tables from both tables, as well as
      // all associated edges.
      for (vertex, associatedIndices) in vertexTable {
         if other.vertexTable.keys.contains(vertex) {
            // Removes the vertex and its edges from this table.
            vertexTable[vertex] = nil
            associatedIndices.forEach { edgeIndexMap[$0] = nil }
            
            // Removes the vertex and its edges from the given table.
            // Forces unrapping is used, as the vertex is known to be safe.
            let foreignIndices = other.vertexTable[vertex]!
            other.vertexTable[vertex] = nil
            foreignIndices.forEach { other.edgeIndexMap[$0] = nil }
         }
      }
      
      // Removes edges contained in both tables from both tables.
      for edge in edgeIndexMap.keys {
         if other.edgeIndexMap.keys.contains(edge) {
            // Removes the edge from both tables.
            edgeIndexMap[edge] = nil
            other.edgeIndexMap[edge] = nil
         }
      }
      
      // Merges the vertex and edge reference tables in this table.
      for (vertex, associatedIndices) in other.vertexTable {
         vertexTable[vertex] = associatedIndices
      }
      for (edge, index) in other.edgeIndexMap {
         edgeIndexMap[edge] = index
      }
   }
}

// MARK: - Graph

extension Graph {
   
   /// Unifies the graph with another given graph.
   public mutating func formUnion(with graph: Graph) {
      table.formUnion(with: graph.table)
   }
   
   /// Removes the vertices and edges from this graph that aren't also in the
   /// given graph.
   public mutating func formIntersection(with graph: Graph) {
      table.formIntersection(with: graph.table)
   }
   
   /// Removes the vertices and edges of the given graph from this graph.
   public mutating func subtract(_ graph: Graph) {
      table.subtract(graph.table)
   }
   
   /// Replaces this graph's vertices and edges with those contained in this
   /// graph or the given graph, but not both.
   public mutating func formSymmetricDifference(with graph: Graph) {
      table.formSymmetricDifference(with: graph.table)
   }
}
