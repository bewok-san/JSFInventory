/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dao;

import com.pojo.Trans;
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
public class TransDAO {
    public List<Trans> getAll(){
        List<Trans> tList = new ArrayList<Trans>();
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        try{
            trans = session.beginTransaction();
            Query query = session.createQuery("from Trans");
            tList = query.list();
            trans.commit();
        } catch (Exception e){
            System.out.println(e);
        }
        session.close();
        return tList;
    }   
    
    public List<Trans> getById(Integer id){
        List<Trans> tList = new ArrayList();
        Trans t = new Trans();
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        
        try{
            trans = session.beginTransaction();
            Query query = session.createQuery("from Trans where id=:id");
            query.setInteger("id",id);
            t = (Trans) query.uniqueResult();
            tList = query.list();
            trans.commit();
        } catch(Exception e){
            System.out.println(e);
        }
        session.close();
        return tList;
    }
    
    public void add(Trans t){
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        try {
            trans = session.beginTransaction();
            session.save(t);
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
            Trans t = (Trans) session.load(Trans.class, new Integer(id));
            session.delete(t);
            trans.commit();
        }catch (Exception e){
            System.out.println(e);
        }
        session.close();
    }
    
    public void edit(Trans t){
        Transaction trans = null;
        Session session = invUtil.getSessionFactory().openSession();
        
        try{
            trans = session.beginTransaction();
            session.update(t);
            trans.commit();
        }catch (Exception e){
            System.out.println(e);
        }
        session.close();
    }
}
