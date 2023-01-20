using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;

public class UIController : MonoBehaviour
{
    public GameController gameController;
    public Player player;

    GameObject distanceText;

    GameObject results;
    TextMeshProUGUI finalDistanceText;

    private void Awake()
    {
        LeaderBoardDataManager.loadData();
        distanceText = GameObject.Find("DistanceText");
        results = GameObject.Find("Results");
        finalDistanceText = GameObject.Find("FinalDistanceText").GetComponent<TextMeshProUGUI>();
        results.SetActive(false);
    }
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    // Updates the shown distance on the top right corner
    void Update()
    {
    }

    public void updateDistanceText(int distance){
        distanceText.GetComponent<TextMeshProUGUI>().text = distance.ToString();
    }

    public void displayGameOverScreen(int finalDistance){
        distanceText.SetActive(false);

        if (LeaderBoardDataManager.checkHighScore(finalDistance)){
            //TODO replace "TST" with actial name from some input
            LeaderBoardDataManager.addScore("TST", finalDistance);
            LeaderBoardDataManager.saveData();
        }

        finalDistanceText.text = finalDistance.ToString();
        results.SetActive(true);

    }
    
    public void ReturnToMenu()
    {
        SceneManager.LoadScene("Menu");
    }

    public void Quit()
    {
       Application.Quit();
    }

    public void Retry()
    {
        SceneManager.LoadScene("MainScene");
    }
}
