# State-based LWW-Element-Graph

LWW-Element-Graph is a Swift (no Cocoa) implementation of a graph data structure, and based on the characteristics of LWW-Element-Set(Last-Write-Wins-Element-Set).<br>
<br>
## Functionalities
The graph contains functionalities:
- Add a vertex/edge
- Remove a vertex/edge
- Check the existence of vertex in the graph
- Query for all vertices connected to a vertex
- Find any path between two vertices
- Merge with concurrent changes from other graph/replica

## Merging
The merging of State-based LWW-Element-Graph conforms to mathematical principles: Associative, Commutative, and Idempotent. 
- **Associative**: 
  <br>
  Rearranging the group of operations has no effect on the outcome.
  <br>
  ``(A merged-with B) merged-with C = A merged-with (B merged-with C)``
- **Commutative**:
  <br>
  Merging order has no effect on the outcome.
  <br>
  ``(A merged-with B) = (B merged-with A)``
- **Idempotent**:
  <br>
  Merging the same values multiple times has no effect on the outcome.
  <br>
  ``A = (A merged-with A)``
  
 ## Testing
 State_based_LWW_Element_GraphTests is the testing for functionalities in LWW-Element-Graph.
  
