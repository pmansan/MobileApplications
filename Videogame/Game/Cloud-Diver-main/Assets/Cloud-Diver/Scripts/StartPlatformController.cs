using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartPlatformController : MonoBehaviour
{

    public GameController gameController;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector2 pos = transform.position;
        pos.x -= gameController.gameSpeed * Time.deltaTime;
        transform.position = pos;
    }

    
}
