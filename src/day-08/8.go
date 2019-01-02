package main

import (
	"fmt"
	"utils"
)

type node struct {
	index         int
	numChildNodes int
	childNodes    []node
	numMetaData   int
	metaData      []int
}

func sumNodeValue(node node) int {
	sum := 0
	if node.numChildNodes == 0 {
		sum = utils.IntSum(node.metaData)
	} else {
		for _, v := range node.metaData {
			if v-1 < node.numChildNodes && v > 0 {
				sum = sum + sumNodeValue(node.childNodes[v-1])
			}
		}
	}
	return sum
}

func sumMeta(node node) int {
	sum := 0
	for _, v := range node.childNodes {
		sum = sum + sumMeta(v)
	}
	for _, v := range node.metaData {
		sum = sum + v
	}
	return sum
}

func getNode(index int, split []string) node {
	node := node{index: index, numChildNodes: utils.Str2Int(split[index]), numMetaData: utils.Str2Int(split[index+1])}
	offset := node.index + 2

	for i := 0; i < node.numChildNodes; i++ {
		childNode := getNode(offset, split)
		node.childNodes = append(node.childNodes, childNode)
		offset = offset + getLength(childNode)
	}

	for i := 0; i < node.numMetaData; i++ {
		node.metaData = append(node.metaData, utils.Str2Int(split[offset+i]))
	}
	return node
}

func getLength(node node) int {
	length := 2
	for i := 0; i < node.numChildNodes; i++ {
		length = length + getLength(node.childNodes[i])
	}
	length = length + node.numMetaData
	return length
}

func main() {
	line := utils.ReadLines("day-08/8.input")[0]
	split := utils.RegSplit(line, " ")
	node := getNode(0, split)

	fmt.Println(node)

	fmt.Println("Sum:", sumMeta(node))
	fmt.Println("Root value:", sumNodeValue(node))
}
