package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"slices"
	"time"
)

type coord struct {
	posX int
	posY int
}

type antenna struct {
	frequency string
	coord     coord
}

func getInput(path string) (arrString []string) {
	file, err := os.Open(path)
	if err != nil {
		fmt.Println("pas de bol")
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		arrString = append(arrString, line)
	}
	return arrString
}

func getAntenna(input []string) (res []antenna) {
	reg := regexp.MustCompile(`[a-zA-Z0-9]`)

	for y, v := range input {
		buffer := reg.FindAllString(v, -1)
		buffer2 := reg.FindAllStringIndex(v, -1)
		for i := 0; i < len(buffer); i++ {
			newCoord := coord{buffer2[i][0], y}
			newAntenna := antenna{buffer[i], newCoord}
			res = append(res, newAntenna)
		}
	}
	return res
}

func makeMap(input []antenna) map[string][]coord {
	m := make(map[string][]coord)
	for _, v := range input {
		m[v.frequency] = append(m[v.frequency], v.coord)
	}
	return m
}

func calculateAntinode(listAntenna []coord, limX, limY int) (res []coord) {
	for _, currentAntenna := range listAntenna {
		adjustedArray := getModifiedArr(currentAntenna, listAntenna)
		for _, otherAntenna := range adjustedArray {
			newCord := newAntinodeCoord(currentAntenna, otherAntenna, limX, limY)
			if newCord.posY != -1 && !slices.Contains(res, newCord) {
				res = append(res, newCord)
			}
		}
	}
	return res
}

func newAntinodeCoord(refCoord, otherCoord coord, lx, ly int) coord {
	X := refCoord.posX*2 - otherCoord.posX
	Y := refCoord.posY*2 - otherCoord.posY
	if !((0 > X || X >= lx) || (0 > Y || Y >= ly)) {
		res := coord{X, Y}
		return res
	}
	res := coord{-1, -1}
	return res
}

func calculateAntinodePart2(listAntenna []coord, limX, limY int) (res []coord) {
	for _, currentAntenna := range listAntenna {
		adjustedArray := getModifiedArr(currentAntenna, listAntenna)
		resInterm := []coord{currentAntenna}
		for _, otherAntenna := range adjustedArray {
			newAntinodeCoordPart2(currentAntenna, otherAntenna, limX, limY, &resInterm)
		}
		res = append(res, resInterm...)
	}
	return res
}

func newAntinodeCoordPart2(refCoord, otherCoord coord, lx, ly int, res *[]coord) {
	X := refCoord.posX*2 - otherCoord.posX
	Y := refCoord.posY*2 - otherCoord.posY
	if !((0 > X || X >= lx) || (0 > Y || Y >= ly)) {
		newCoord := coord{X, Y}
		*res = append(*res, newCoord)
		newAntinodeCoordPart2(newCoord, refCoord, lx, ly, res)
	}
}

func getModifiedArr(j coord, arr []coord) (res []coord) {
	for i := 0; i < len(arr); i++ {
		if arr[i] != j {
			res = append(res, arr[i])
		}
	}
	return res
}

func coordToArr(c coord) (m [2]int) {
	m = [2]int{c.posX, c.posY}
	return m
}

func antennaToCoord(a antenna) (c coord) {
	return a.coord
}

func listAntennaToListCoord(in []antenna) (out []coord) {
	for _, v := range in {
		coord := antennaToCoord(v)
		out = append(out, coord)
	}
	return out
}

func removePairs(in [][]coord) (out []coord) {
	out = in[0]
	for i := 1; i < len(in); i++ {
		for _, currentCoord := range in[i] {
			if !slices.Contains(out, currentCoord) {
				out = append(out, currentCoord)
			} //else {
			//fmt.Println("found duplicate", currentCoord)
			//}
		}
	}
	return out
}

func main() {
	//part1
	input := getInput("input")
	limX := len(input[0])
	limY := len(input)

	antenna := getAntenna(input)
	antennaMap := makeMap(antenna)
	startPart1 := time.Now()
	var allThePossibleAntinode [][]coord
	for _, v := range antennaMap {
		allThePossibleAntinode = append(allThePossibleAntinode, calculateAntinode(v, limX, limY))
	}
	antinode := removePairs(allThePossibleAntinode)

	//print zone
	//fmt.Println(antinode)
	//fmt.Println(allThePossibleAntinode[0])
	//fmt.Println(antenna)
	//fmt.Println(antennaMap)

	elapsedPart1 := time.Since(startPart1)
	fmt.Println("result part 1 :", len(antinode), ", took :", elapsedPart1)
	startPart2 := time.Now()
	var allThePossibleAntinodePart2 [][]coord
	for _, v := range antennaMap {
		allThePossibleAntinodePart2 = append(allThePossibleAntinodePart2, calculateAntinodePart2(v, limX, limY))
	}
	antinodePart2 := removePairs(allThePossibleAntinodePart2)
	elapsedPart2 := time.Since(startPart2)
	fmt.Println("result part 2 :", len(antinodePart2), ", took :", elapsedPart2)
}
