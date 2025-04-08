<?php
use PHPUnit\Framework\TestCase;
use Demo\File89;

class File89Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File89::add(2, 3));
    }
}
