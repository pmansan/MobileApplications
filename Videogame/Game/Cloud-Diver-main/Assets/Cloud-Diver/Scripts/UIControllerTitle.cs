using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Video;
using UnityEngine.SceneManagement;

public class UIControllerTitle : MonoBehaviour
{
    public RawImage m_RawImage;
    public Texture idleTexture;
    public Texture startTexture;
    public VideoPlayer startAnimation;
    public float counter = 0;
    public bool hasStarted = false;

    // Start is called before the first frame update
    void Start()
    {
        GameObject.Find("PlayButton").GetComponent<Button>().enabled = false;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if(counter < 5)
        {
            counter += Time.fixedDeltaTime;
        }
        else
        {
            if (!hasStarted)
            {
                GameObject.Find("PlayButton").GetComponent<Button>().enabled = true;
                m_RawImage = GameObject.Find("RawImage").GetComponent<RawImage>();
                m_RawImage.texture = idleTexture;
                hasStarted = true;
            }
        }
        //if intro ended, enable button
    }

    public void Quit() {
        Application.Quit();
    }

    public void toLeaderBoard(){
    
        UnityEngine.SceneManagement.SceneManager.LoadScene("LeaderBoard");

    }

    public void Play()
    {
        m_RawImage.texture = startTexture;    //run game start animation
        startAnimation.Play();
        startAnimation.loopPointReached += LoadScene;
        
        //SceneManager.LoadScene("MainScene");
    }

    void LoadScene(VideoPlayer vp)
    {
        SceneManager.LoadScene("MainScene");
    }
}   
    
    