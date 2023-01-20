using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;

public class LeaderBoardUIController : MonoBehaviour
{
    public TextMeshProUGUI lbText;
    void Start()
    {
       LeaderBoardDataManager.loadData();
       lbText.text = LeaderBoardDataManager.getData();
    }


    public void GoToMenu(){
        SceneManager.LoadScene("Menu");
    }
}
