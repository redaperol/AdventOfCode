package main

import (
	"bufio"
	"fmt"
	"os"
	//	"sync"
	"time"
)

type SearchDirection struct {
	direction string
	Xmodifier int
	Ymodifier int
}

func univChecker(x, y int, arr []string) int {
	res := 0
	limX := len(arr)
	limY := len(arr[0])
	MaxX := x + 3
	MinX := x - 3
	MaxY := y + 3
	MinY := y - 3

	directionToDo := [8]SearchDirection{
		{"left", 0, -1},
		{"right", 0, 1},
		{"up", -1, 0},
		{"down", 1, 0},
		{"leftdown", 1, -1},
		{"leftup", -1, -1},
		{"rightdown", 1, 1},
		{"rightup", -1, 1},
	}

	for _, j := range directionToDo {
		goodToGO := false
		switch j.direction {
		case "left":
			//fmt.Println("left")
			if MinY >= 0 {
				goodToGO = true
			}
		case "right":
			//fmt.Println("right")
			if MaxY < limY {
				goodToGO = true
			}
		case "up":
			//fmt.Println("up")
			if x+3*j.Xmodifier >= 0 {
				goodToGO = true
			}
		case "down":
			//fmt.Println("down")
			if MaxX < limX {
				goodToGO = true
			}
		case "leftdown":
			//fmt.Println("leftdown")
			if MinY >= 0 && MaxX < limX {
				goodToGO = true
			}
		case "leftup":
			//fmt.Println("leftup")
			if MinY >= 0 && MinX >= 0 {
				goodToGO = true
			}
		case "rightdown":
			//fmt.Println("rightdown")
			if MaxY < limY && MaxX < limX {
				goodToGO = true
			}
		case "rightup":
			//fmt.Println("rightup")
			if MaxY < limY && MinX >= 0 {
				goodToGO = true
			}
		}
		// X := 88
		// M := 77
		// A := 65
		// S := 83
		if goodToGO {
			if arr[x+1*j.Xmodifier][y+1*j.Ymodifier] == 77 && arr[x+2*j.Xmodifier][y+2*j.Ymodifier] == 65 && arr[x+3*j.Xmodifier][y+3*j.Ymodifier] == 83 {
				res++
			}
		}
	}
	return res
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

func searchFor(val byte, arr []string) (arrPos [][2]int) {
	for i := 0; i < len(arr); i++ {
		for j := 0; j < len(arr[i]); j++ {
			if arr[i][j] == val {
				buffarr := [2]int{i, j}
				arrPos = append(arrPos, buffarr)
			}
		}
	}
	return arrPos
}

func AvalSanitizer(arrIn [][2]int, maxX, maxY int) (arrOut [][2]int) {
	for i := 0; i < len(arrIn); i++ {
		if (arrIn[i][0] > 0 && arrIn[i][0] < maxX) && (arrIn[i][1] > 0 && arrIn[i][1] < maxY) {
			arrOut = append(arrOut, arrIn[i])
		}
	}
	return arrOut
}

func checkerPart2(x, y int, inp []string) bool {
	//position to check
	valtoCheck := [4]byte{
		inp[x-1][y-1],
		inp[x-1][y+1],
		inp[x+1][y-1],
		inp[x+1][y+1],
	}
	Mcount := 0
	Scount := 0
	for _, v := range valtoCheck {
		switch v {
		case 77:
			Mcount++
		case 83:
			Scount++
		default:
			return false
		}
	}
	if Mcount == 2 && Scount == 2 {
		if inp[x-1][y-1]+inp[x+1][y+1] == 77+83 {
			return true
		} else {
			return false
		}
	} else {
		return false
	}
}

func main() {
	start := time.Now()
	input := getInput("input")
	Xval := searchFor(88, input)
	var xmasCount int

	for i := 0; i < len(Xval); i++ {
		xmasCount += univChecker(Xval[i][0], Xval[i][1], input)
	}
	println("Solution part 1 ", xmasCount)
	elapsed := time.Since(start)
	fmt.Println("took : ", elapsed)

	//part 2
	startPart2 := time.Now()
	Aval := searchFor(65, input)
	sanAval := AvalSanitizer(Aval, len(input)-1, len(input[0])-1)
	var masCount int

	for i := 0; i < len(sanAval); i++ {
		if checkerPart2(sanAval[i][0], sanAval[i][1], input) {
			masCount++
		}
	}
	println("Solution part 2 ", masCount)
	elapsedPart2 := time.Since(startPart2)
	fmt.Println("took : ", elapsedPart2)
}
