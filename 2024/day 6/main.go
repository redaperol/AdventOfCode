package main

import (
	"bufio"
	"fmt"
	"os"
	//	"sync"
	"regexp"
	"slices"
	"time"
)

type record struct {
	direction string
	posX      int
	posY      int
}

func getXYFromDir(input string) (Xmod, Ymod int) {
	switch input {
	case "up":
		Xmod = 0
		Ymod = -1
	case "down":
		Xmod = 0
		Ymod = 1
	case "left":
		Xmod = -1
		Ymod = 0
	case "right":
		Xmod = 1
		Ymod = 0
	}
	return Xmod, Ymod
}

func getNewDirection(previousDirection string) (newDirection string) {
	switch previousDirection {
	case "up":
		newDirection = "right"
	case "down":
		newDirection = "left"
	case "left":
		newDirection = "up"
	case "right":
		newDirection = "down"
	}
	return newDirection
}

func isObstacle(Xstart, Ystart, limX, limY int, direction string, obslist [][2]int) bool {
	Xmodifier, Ymodifier := getXYFromDir(direction)
	steps := 1
	for true {
		if (0 <= Xstart+steps*Xmodifier && Xstart+steps*Xmodifier < limX) && (0 <= Ystart+steps*Ymodifier && Ystart+steps*Ymodifier < limY) {
			currentBlock := [2]int{Xstart + steps*Xmodifier, Ystart + steps*Ymodifier}
			if slices.Contains(obslist, currentBlock) {
				return true
			} else {
				steps++
			}
		} else {
			return false
		}
	}
	return false
}

func createNewRecord(originRecord record, steps int) record {
	Xmod, Ymod := getXYFromDir(originRecord.direction)
	newRecord := record{originRecord.direction, originRecord.posX + steps*Xmod, originRecord.posY + steps*Ymod}
	return newRecord
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

func getObstacle(input []string) (arrRes [][2]int) {
	reg := regexp.MustCompile(`#`)

	for ind, v := range input {
		buffer := reg.FindAllStringIndex(v, -1)
		for _, u := range buffer {
			obsPos := []int{u[0], ind}
			arrRes = append(arrRes, [2]int(obsPos))
		}
	}
	return arrRes
}

func getGuard(input []string) (res [2]int) {
	reg := regexp.MustCompile(`\^`)
	for ind, v := range input {
		buffer := reg.FindStringIndex(v)
		if buffer != nil {
			res := [2]int{buffer[0], ind}
			return res
		}
	}
	res = [2]int{-1, -1}
	return res
}

func moveUpdated(startRecord record, limX, limY int, obsArr [][2]int) (visitedRecord []record) {
	var currentSteps int
	steps := 1
	Xmodifier, Ymodifier := getXYFromDir(startRecord.direction)

	for (0 <= startRecord.posX+steps*Xmodifier && startRecord.posX+steps*Xmodifier < limX) && (0 <= startRecord.posY+steps*Ymodifier && startRecord.posY+steps*Ymodifier < limY) {
		nextBlock := [2]int{startRecord.posX + steps*Xmodifier, startRecord.posY + steps*Ymodifier}
		if slices.Contains(obsArr, nextBlock) {
			return visitedRecord
		}
		steps++
		currentSteps = steps - 1
		currentRecord := createNewRecord(startRecord, currentSteps)
		visitedRecord = append(visitedRecord, currentRecord)
	}
	lastRecord := record{startRecord.direction, -1, -1}
	visitedRecord = append(visitedRecord, lastRecord)
	return visitedRecord
}

func processUpdated(posStart record, limX, limY int, obstacle [][2]int) []record {
	travelHistory := []record{posStart}
	keepGoing := true

	for keepGoing {
		visitedBlock := moveUpdated(posStart, limX, limY, obstacle)
		if visitedBlock[len(visitedBlock)-1].posX == -1 {
			keepGoing = false
		}
		travelHistory = append(travelHistory, visitedBlock...)
		posStart = visitedBlock[len(visitedBlock)-1]
		newDirection := getNewDirection(posStart.direction)
		posStart.direction = newDirection
	}
	travelHistory = travelHistory[:len(travelHistory)-1]
	return travelHistory
}

func processPart2(posStart record, limX, limY int, obstacle [][2]int) (loopStatus bool) {
	travelHistory := []record{posStart}
	keepGoing := true

	for keepGoing {
		visitedBlock := moveUpdated(posStart, limX, limY, obstacle)
		if len(visitedBlock) != 0 {
			if visitedBlock[len(visitedBlock)-1].posX == -1 {
				keepGoing = false
				loopStatus = false
			}
			if isInAloop(travelHistory, visitedBlock) {
				keepGoing = false
				return true
			}
			travelHistory = append(travelHistory, visitedBlock...)
			posStart = visitedBlock[len(visitedBlock)-1]
		}

		newDirection := getNewDirection(posStart.direction)
		posStart.direction = newDirection
	}
	return loopStatus
}

func getPossibleCandidate(limX, limY int, obstacle [][2]int, inpRecords []record) (outRecords []record) {
	for _, v := range inpRecords {
		if isObstacle(v.posX, v.posY, limX, limY, getNewDirection(v.direction), obstacle) {
			outRecords = append(outRecords, v)
		}
	}
	return outRecords
}

func isInAloop(travelHistory []record, recentRecord []record) bool {
	for _, r := range recentRecord {
		if slices.Contains(travelHistory, r) {
			return true
		}
	}
	return false
}

func getPreviousRecord(fullList []record, input record) (previousRecord record) {
	index := slices.Index(fullList, input) - 1
	previousRecord = fullList[index]
	return previousRecord
}

func getPart1Answer(input []record) int {
	var buffer [][2]int
	for _, v := range input {
		tempArr := [2]int{v.posX, v.posY}
		if !slices.Contains(buffer, tempArr) {
			buffer = append(buffer, tempArr)
		}
	}
	//fmt.Println(buffer)
	return len(buffer)
}

func main() {
	input := getInput("input")
	limX := len(input[0])
	limY := len(input)
	obstacle := getObstacle(input)
	PosGuard := getGuard(input)
	guardRecord := record{"up", PosGuard[0], PosGuard[1]}

	//part1
	startPart1 := time.Now()
	travelHistory := processUpdated(guardRecord, limX, limY, obstacle)
	elapsedPart1 := time.Since(startPart1)
	fmt.Println("result part 1 :", getPart1Answer(travelHistory), ", took : ", elapsedPart1)
	//part2
	startPart2 := time.Now()
	//candidateForObstacle := getPossibleCandidate(limX, limY, obstacle, travelHistory)
	//fmt.Println(travelHistory)

	var loopCounter int
	var listBlockCreate [][2]int
	for _, r := range travelHistory[1:] {
		previousRecord := getPreviousRecord(travelHistory, r)
		newObstacle := [2]int{r.posX, r.posY}
		if !slices.Contains(listBlockCreate, newObstacle) {
			updatedObstacle := append(obstacle, newObstacle)
			listBlockCreate = append(listBlockCreate, newObstacle)
			if processPart2(previousRecord, limX, limY, updatedObstacle) {
				loopCounter++
			}
		}
	}

	elapsedPart2 := time.Since(startPart2)
	fmt.Println("result part 2 :", loopCounter, ", took : ", elapsedPart2)
}
