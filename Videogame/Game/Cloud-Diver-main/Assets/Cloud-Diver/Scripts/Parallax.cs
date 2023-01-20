using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Parallax : MonoBehaviour
{
    public float depth = 1;     //affects how far from the front the object appears (the higher the depth, the farthest the object is)

    Player player;

    private void Awake()
    {
        player = GameObject.Find("Player").GetComponent<Player>();   //gets player component
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once every fixedDeltaTime (very short amount of time)
    void FixedUpdate()
    {
        //float realVelocity = player.velocity.x / depth;   //object velocity, depending on its depth
        Vector2 pos = transform.position;

        //pos.x -= realVelocity * Time.fixedDeltaTime;  //updates objects position to make it move

        if(pos.x <= -30)
        {
            pos.x = 70;   //if object leaves screen, makes it loop back around to create infinite background
        }

        transform.position = pos;   //establishes previously updated position
    }
}
