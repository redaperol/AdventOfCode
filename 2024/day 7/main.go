package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	//	"sync"
	"regexp"
	//"slices"
	"time"
)

type equation struct {
	result int
	number []int
}

type operation struct {
	multiply string
	add      string
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

func getEquations(input []string) (arrRes []equation) {
	reg := regexp.MustCompile(`\d+`)

	for _, v := range input {
		buffer := reg.FindAllStringSubmatch(v, -1)
		res, _ := strconv.Atoi(buffer[0][0])
		var bufferArr []int
		for i := 1; i < len(buffer); i++ {
			conv, _ := strconv.Atoi(buffer[i][0])
			bufferArr = append(bufferArr, conv)
		}
		equ := equation{res, bufferArr}
		arrRes = append(arrRes, equ)
	}
	return arrRes
}

func doOperation(a, b int, operation string) (e int) {
	switch operation {
	case "mult":
		e = multiply(a, b)
	case "add":
		e = add(a, b)
	}
	return e
}

func adjustArray(a int, arr []int) (res []int) {
	res = append(res, a)
	res = append(res, arr[2:]...)
	return res
}

func multiply(a, b int) int {
	return a * b
}

func add(a, b int) int {
	return a + b
}

func equationTester(toReach int, numb []int) (isSolvable bool) {
	listOperation := []string{
		"mult",
		"add",
	}
	for _, o := range listOperation {
		resultOperation := doOperation(numb[0], numb[1], o)
		if resultOperation == toReach && 2 == len(numb) {
			return true
		}
		if toReach > resultOperation && len(numb) > 2 {
			adjustedNumb := adjustArray(resultOperation, numb)
			isSolvable = equationTester(toReach, adjustedNumb)
			if isSolvable {
				return true
			}
		}
	}
	return isSolvable
}

func process(arr []equation) (count, countSolvable, countUnSolvable int) {
	for _, e := range arr {
		if equationTester(e.result, e.number) {
			count += e.result
			countSolvable++
			//fmt.Printf("%v is solvable \n", e)
		} else {
			//fmt.Printf("%v is unsolvable\n", e)
			countUnSolvable++
		}
	}
	return count, countSolvable, countUnSolvable
}

func main() {
	input := getInput("input")
	unsolveEquation := getEquations(input)
	start1 := time.Now()
	answerPart1, solvable, unsolvable := process(unsolveEquation)
	elapsed1 := time.Since(start1)
	fmt.Printf("%v equation treated, found %v solvable %v unsolvable \n", len(unsolveEquation), solvable, unsolvable)
	fmt.Printf("Part1 answer : %v, took : %v \n", answerPart1, elapsed1)
}
