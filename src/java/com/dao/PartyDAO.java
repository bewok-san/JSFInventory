/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dao;

import com.pojo.Party;
import com.util.invUtil;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author ASUS
 */
public class PartyDAO {
    public List<Party> getAll(){
        List<Party> pList = new ArrayList<Party>();
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        try{
            trans = session.beginTransaction();
            Query query = session.createQuery("from Party");
            pList = query.list();
            trans.commit();
        } catch (Exception e){
            System.out.println(e);
        }
        session.close();
        return pList;
    }   
    
    public List<Party> getById(Integer id){
        List<Party> pList = new ArrayList();
        Party p = new Party();
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        
        try{
            trans = session.beginTransaction();
            Query query = session.createQuery("from Party where id=:id");
            query.setInteger("id",id);
            p = (Party) query.uniqueResult();
            pList = query.list();
            trans.commit();
        } catch(Exception e){
            System.out.println(e);
        }
        session.close();
        return pList;
    }
    
    public void add(Party party){
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        try {
            trans = session.beginTransaction();
            session.save(party);
            trans.commit(); 
        } catch (Exception e){
            System.out.println(e);
        }
        session.close();
    }
    
    public void delete(Integer id){
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        
        try{
            trans = session.beginTransaction();
            Party party = (Party) session.load(Party.class, new Integer(id));
            session.delete(party);
            trans.commit();
        }catch (Exception e){
            System.out.println(e);
        }
        session.close();
    }
    
    public void edit(Party party){
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        
        try{
            trans = session.beginTransaction();
            session.update(party);
            trans.commit();
        }catch (Exception e){
            System.out.println(e);
        }
        session.close();
    }
}
