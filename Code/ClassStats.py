def statistics(n):
    classavg = []
    for key in n:
        print("\n")
        print("Max score for "+key+" is "+str(max(n[key])))
        print("Min score for "+key+" is "+str(min(n[key])))
        avg = sum(n[key])/len(n[key])
        classavg.append(avg);
        print("Average score for "+key+" is "+str(avg))
        if (avg >= 90):
            print("Average grade for "+key+" is an A")
        elif (avg>=80):
            print("Average grade for "+key+" is a B")
        elif (avg>=70):
            print("Average grade for "+key+" is a C")
        elif (avg>=60):
            print("Average grade for "+key+" is a D")
        else:
            print("Average grade for "+key+" is an F")
        print("\n")        
        
    print("The class average is "+str(sum(classavg)/len(classavg)))

n = {}
for i in range(5):
    s = str(input("Please enter name:"))
    n[s] = [float(input('Enter a value: ')) for i in range(2)]
statistics(n)