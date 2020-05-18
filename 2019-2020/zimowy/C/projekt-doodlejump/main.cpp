#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <time.h>
#include <unistd.h>
using namespace sf;

struct point
{
    int x,y;
};

int main()
{
    RenderWindow app(VideoMode(400, 533), "Jump Game!");
    app.setFramerateLimit(60);
start:
    Texture t7;
    t7.loadFromFile("images/newgame.png");
    Sprite sNewgame(t7);
    SoundBuffer buffer;
    Sound sound;
    sound.setBuffer(buffer);
    buffer.loadFromFile("sound/menu.wav");
    sound.play();

    Font font;
    font.loadFromFile("font/arial.ttf");
    Text scoreText;
    scoreText.setFont(font);
    scoreText.setCharacterSize(35);
    scoreText.setFillColor(sf::Color::Blue);
    Text levelText;
    levelText.setFont(font);
    levelText.setCharacterSize(35);
    levelText.setFillColor(sf::Color::Blue);
    Text level1Text;
    level1Text.setFont(font);
    level1Text.setCharacterSize(20);
    level1Text.setFillColor(sf::Color::Blue);
    level1Text.setPosition(208,509);
    level1Text.setString("next level: score>150");
    Text level2Text;
    level2Text.setFont(font);
    level2Text.setCharacterSize(20);
    level2Text.setFillColor(sf::Color::Red);
    level2Text.setPosition(208,509);
    level2Text.setString("next level: score>100");


    Text EZ;
    EZ.setFont(font);
    EZ.setCharacterSize(50);
    EZ.setFillColor(sf::Color::Blue);

    srand(time(0));

    Texture t1,t2,t3,t4,t5,t6,t8,t9,t10,t11,t12,t13;
    t1.loadFromFile("images/background.png");
    t2.loadFromFile("images/platform.png");
    t3.loadFromFile("images/doodle.png");
    t4.loadFromFile("images/platform2v2.png");
    t5.loadFromFile("images/gameover2.png");
    t6.loadFromFile("images/platform3.png");
    t8.loadFromFile("images/background2lvl.png");
    t9.loadFromFile("images/platform3v2.png");
    t10.loadFromFile("images/endgame.png");
    t11.loadFromFile("images/select.png");
    t12.loadFromFile("images/doodle2.png");
    t13.loadFromFile("images/nextlevel.png");
    Sprite sBackground(t1), sPlat(t2), sPers(t3),sPlat2(t4),sGameover(t5),sPlat3(t6),sBackground2(t8),sPlat4(t9),sEndgame(t10),sSelect(t11),sPers2(t12),sWait(t13);
    int level=0,alive=1;
    int x=100,y=100,h=200,score=0;
    float dy=0;

    while (app.isOpen())
    {
        Event event;
        while (app.pollEvent(event))
        {
            if (event.type == Event::Closed)
                app.close();
            if (Keyboard::isKeyPressed(Keyboard::Space))
            {
                goto game;
            }
            if(Keyboard::isKeyPressed(Keyboard::Escape))
            {
                return 0;
            }
            if(Keyboard::isKeyPressed(Keyboard::X))
            {
                goto select;
            }
        }
        app.draw(sNewgame);
        app.display();
    }
select:
    while (app.isOpen())
    {
        Event event;
        while (app.pollEvent(event))
        {
            if (event.type == Event::Closed)
                app.close();
            if(Keyboard::isKeyPressed(Keyboard::Escape))
            {
                goto start;
            }
            if(Keyboard::isKeyPressed(Keyboard::Num1))
            {
                goto game;
            }
            if(Keyboard::isKeyPressed(Keyboard::Num2))
            {
                goto game2;
            }
        }
        app.draw(sSelect);
        app.display();
    }


game:
    alive=4;
    scoreText.setFillColor(sf::Color::Blue);
    h=200,score=0;
    dy=0;
    point plat[10];
    point plat2[2];
    point plat3;
    level=1;
    for (int i=0; i<10; i++)
    {
        plat[i].x=rand()%400;
        plat[i].y=rand()%533;
    }
    for(int i=0; i<2; i++)
    {
        plat2[i].x=rand()%400;
        plat2[i].y=rand()%533;
    }
    plat3.x=rand()%400;
    plat3.y=rand()%553;

    x=plat[0].x;
    y=plat[0].y;
    while (app.isOpen())
    {
        Event e;
        while (app.pollEvent(e))
        {
            if (e.type == Event::Closed)
                app.close();
        }

        if (Keyboard::isKeyPressed(Keyboard::Right))
            x+=3;

        if (Keyboard::isKeyPressed(Keyboard::Left))
            x-=3;

        if(x>400)
            x=12;

        if(x<-50)
            x=382;

        if(y>500)
        {

            if(alive<2 || score>0)
            {
                buffer.loadFromFile("sound/die.wav");
                sound.play();
                goto gameover;
            }
            dy-=30;
            alive--;
        }

        dy+=0.2;
        y+=dy;

        if(y==h && dy<0)
            score+=1;

        scoreText.setString("Score: " + std::to_string(score));
        if (y<h)
            for (int i=0; i<10; i++)
            {
                y=h;
                plat[i].y=plat[i].y-dy;
                if (plat[i].y>533)
                {
                    plat[i].y=0;
                    plat[i].x=rand()%440;
                }
            }

        for (int i=0; i<2; i++)
        {
            plat2[i].y=plat2[i].y-dy;
            if (plat2[i].y>533)
            {
                plat2[i].y=0;
                plat2[i].x=rand()%400;
            }
        }

        plat3.y=plat3.y-dy;
        if (plat3.y>533)
        {
            plat3.y=0;
            plat3.x=rand()%400;
        }


        for (int i=0; i<10; i++)
            if ((x+50>plat[i].x) && (x+20<plat[i].x+68)
                    && (y+70>plat[i].y) && (y+70<plat[i].y+14) && (dy>0))
            {
                dy=-10;
                buffer.loadFromFile("sound/jump.wav");
                sound.play();
            }

        sPers2.setPosition(x,y);
        for (int i=0; i<2; i++)
            if ((x+50>plat2[i].x) && (x+20<plat2[i].x+68)
                    && (y+70>plat2[i].y) && (y+70<plat2[i].y+14) && (dy>0))
            {
                if(alive<2 || score>0)
                {
                    buffer.loadFromFile("sound/die.wav");
                    sound.play();
                    goto gameover;
                }
                alive--;

            }

        if ((x+50>plat3.x) && (x+20<plat3.x+68)
                && (y+70>plat3.y) && (y+70<plat3.y+14) && (dy>0))
        {
            dy=-20;
            score+=20;
            buffer.loadFromFile("sound/bigjump.wav");
            sound.play();
        }

        if(score>150)
        {
            app.draw(sWait);
            app.display();
            sleep(5);
            goto game2;
        }

        app.draw(sBackground);
        app.draw(sPers2);

        for (int i=0; i<10; i++)
        {
            sPlat.setPosition(plat[i].x,plat[i].y);
            app.draw(sPlat);
        }
        for (int i=0; i<2; i++)
        {
            sPlat2.setPosition(plat2[i].x,plat2[i].y);
            app.draw(sPlat2);
        }

        sPlat3.setPosition(plat3.x,plat3.y);
        app.draw(sPlat3);

        scoreText.setPosition(0,0);
        app.draw(scoreText);
        app.draw(level1Text);
        app.display();
    }


game2:

    alive=4;
    scoreText.setFillColor(sf::Color::Red);
    h=200,score=0;
    dy=0;
    point plat_lvl2[5];
    point plat2_lvl2[3];
    point plat3_lvl2;
    level=2;

    for (int i=0; i<5; i++)
    {
        plat_lvl2[i].x=rand()%350;
        plat_lvl2[i].y=rand()%533;
    }

    for(int i=0; i<3; i++)
    {
        plat2_lvl2[i].x=rand()%400;
        plat2_lvl2[i].y=rand()%533;
    }

    plat3_lvl2.x=rand()%350;
    plat3_lvl2.y=rand()%553;

    x=plat_lvl2[0].x;
    y=plat_lvl2[0].y;

    while (app.isOpen())
    {
        Event e;
        while (app.pollEvent(e))
        {
            if (e.type == Event::Closed)
                app.close();
        }

        if (Keyboard::isKeyPressed(Keyboard::Right))
            x+=3;

        if (Keyboard::isKeyPressed(Keyboard::Left))
            x-=3;

        if(x>400)
            x=12;

        if(x<-50)
            x=382;

        if(y>500)
        {
            if(alive<2 || score>0)
            {
                buffer.loadFromFile("sound/die.wav");
                sound.play();
                goto gameover;
            }
            dy-=30;
            alive--;
        }

        dy+=0.188;
        y+=dy;

        if(y==h && dy<0.2)
            score+=1;

        scoreText.setString("Score: " + std::to_string(score));
        if (y<h)
            for (int i=0; i<5; i++)
            {
                y=h;
                plat_lvl2[i].y=plat_lvl2[i].y-dy;
                if (plat_lvl2[i].y>533)
                {
                    plat_lvl2[i].y=0;
                    plat_lvl2[i].x=rand()%350;
                }
            }

        for (int i=0; i<3; i++)
        {
            plat2_lvl2[i].y=plat2_lvl2[i].y-dy;
            if (plat2_lvl2[i].y>533)
            {
                plat2_lvl2[i].y=0;
                plat2_lvl2[i].x=rand()%400;
            }
        }
        plat3_lvl2.y=plat3_lvl2.y-dy;
        if (plat3_lvl2.y>533)
        {
            plat3_lvl2.y=0;
            plat3_lvl2.x=rand()%350;
        }


        for (int i=0; i<5; i++)
            if ((x+50>plat_lvl2[i].x) && (x+20<plat_lvl2[i].x+68)
                    && (y+70>plat_lvl2[i].y) && (y+70<plat_lvl2[i].y+14) && (dy>0))
            {
                dy=-11;
                buffer.loadFromFile("sound/jump.wav");
                sound.play();
            }

        sPers.setPosition(x,y);

        for (int i=0; i<3; i++)
            if ((x+50>plat2_lvl2[i].x) && (x+20<plat2_lvl2[i].x+68)
                    && (y+70>plat2_lvl2[i].y) && (y+70<plat2_lvl2[i].y+14) && (dy>0))
            {
                if(alive<2 || score>0)
                {
                    buffer.loadFromFile("sound/die.wav");
                    sound.play();
                    goto gameover;
                }
                alive--;
            }

        if ((x+50>plat3_lvl2.x) && (x+20<plat3_lvl2.x+68)
                && (y+70>plat3_lvl2.y) && (y+70<plat3_lvl2.y+14) && (dy>0))
        {
            dy=-20;
            score+=20;
            buffer.loadFromFile("sound/bigjump.wav");
            sound.play();
        }

        if(score>100)
        {
            goto finish;
        }

        app.draw(sBackground2);
        app.draw(sPers);

        for (int i=0; i<5; i++)
        {
            sPlat.setPosition(plat_lvl2[i].x,plat_lvl2[i].y);
            app.draw(sPlat);
        }

        for (int i=0; i<3; i++)
        {
            sPlat4.setPosition(plat2_lvl2[i].x,plat2_lvl2[i].y);
            app.draw(sPlat4);
        }


        sPlat3.setPosition(plat3_lvl2.x,plat3_lvl2.y);
        app.draw(sPlat3);

        scoreText.setPosition(0,0);
        app.draw(scoreText);
        app.draw(level2Text);
        app.display();
    }



gameover:
    scoreText.setFillColor(sf::Color::Blue);
    buffer.loadFromFile("sound/menu.wav");
    sound.play();
    while (app.isOpen())
    {
        Event event;
        while (app.pollEvent(event))
        {
            if (event.type == Event::Closed)
                app.close();
            if (Keyboard::isKeyPressed(Keyboard::X))
            {
                goto start;
            }
            if(Keyboard::isKeyPressed(Keyboard::Space))
            {
                goto game;
            }
            if(Keyboard::isKeyPressed(Keyboard::Escape))
            {
                return 0;
            }
        }
        EZ.setPosition(208,200);


        app.draw(sGameover);
        app.draw(EZ);
        levelText.setString("Level: " + std::to_string(level));
        scoreText.setPosition(180, 188);
        levelText.setPosition(188,230);
        app.draw(scoreText);
        app.draw(levelText);
        app.display();
    }

finish:
    buffer.loadFromFile("sound/menu.wav");
    sound.play();
    while (app.isOpen())
    {
        Event event;
        while (app.pollEvent(event))
        {
            if (event.type == Event::Closed)
                app.close();
            if (Keyboard::isKeyPressed(Keyboard::X))
            {
                goto start;
            }
            if (Keyboard::isKeyPressed(Keyboard::Space))
            {
                goto game;
            }
            if(Keyboard::isKeyPressed(Keyboard::Escape))
            {
                return 0;
            }
        }
        app.draw(sEndgame);
        app.display();
    }

    return 0;
}
