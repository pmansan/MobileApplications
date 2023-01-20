using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public static class LeaderBoardDataManager
{
    private struct LeaderBoardEntry{
        public string name;
        public int score;

        public LeaderBoardEntry(string name, int score){
            this.name = name;
            this.score = score;
        }

        public override string ToString(){
            return name + "," + score.ToString();
        }  
    }

    public static int capacityLimit = 5;
    private const string defaultPath = "data/cloud_diver.lb";

    private static List<LeaderBoardEntry> leaderBoardData = new List<LeaderBoardEntry>();

    private static int findInsertIndex(int score){
        int i = 0;
        while(i < leaderBoardData.Count && score < leaderBoardData[i].score ){
            i += 1;
        }
        return i;
    }

    public static string getData(){
        string output = "";
        foreach(LeaderBoardEntry entry in leaderBoardData){
            output = output + entry.name + "\t" + entry.score + "\n";
        }
        return output;
    }
    public static bool checkHighScore(int score){
        int i = findInsertIndex(score);
        
        if (i == 0){
            return true;
        }

        return i <= leaderBoardData.Count;
    }

    public static void addScore(string name, int score){

        int i = findInsertIndex(score);

        leaderBoardData.Insert(i, new LeaderBoardEntry(name, score));

        if(leaderBoardData.Count > capacityLimit){
            leaderBoardData.RemoveAt(leaderBoardData.Count - 1);
        }
    }

    // Loads leaderboard data from file
    public static void loadData(string path = defaultPath){
        if(!System.IO.File.Exists(path)){
            return;
        }

        if(leaderBoardData.Count > 0){
            return;
        }

        foreach (string line in System.IO.File.ReadLines(path))
        {  
            string[] splitLine = line.Split(',');
            string name = splitLine[0];
            int score = int.Parse(splitLine[1]);
            leaderBoardData.Add(new LeaderBoardEntry(name, score));
        }  
    }

    // Saves leaderboard data in file
    public static void saveData(string path = defaultPath){
        using(StreamWriter sw = new StreamWriter(path, false))
        foreach(LeaderBoardEntry entry in leaderBoardData){
           sw.WriteLine(entry.ToString());
        }
    }
}
